# The Chronar Programming Language Specification (v0.3)

**Chronar** is an esoteric, procedurally-executed, object-oriented language designed around the manipulation of concurrent reality timelines. It uses a quantum-superposition model where code executes across branching timelines, and a synchronization barrier collapses them back into observable results.

## 1. Lexical Structure

*   **Greedy Word Identifiers:** Any sequence of words, after stripping leading/trailing whitespace, is a single identifier token. Example: `my cool variable`.
*   **Punctuation Operators:** All other language constructs are formed by punctuation characters. This cleanly separates data (Words) from mechanics (Punctuation).
*   **Significant Newlines:** Newlines act as statement terminators.
*   **Comments:** `#` begins a comment that extends to the end of the line.
*   **Arguments:** Arguments are put in parentheses and separated by commas. If unambiguous, parentheses can be omitted.

## 2. Data Types & Literals

*   **Number:** `123`, `123.45` or `+123.45e-12`
*   **String:** `"abcde"` (always double quotes)
*   **Object:** `[ ... ]` An ordered dictionary that can also serve as an array (with 1-based indexing).
*   **void:** The absence of a meaningful value (e.g., the result of a fork operation in the Trunk).
*   **true** and **false**: The boolean values. Comparison operators return these.
*   **Mark:** A first-class snapshot of the current timeline state. Yielded by the `*` operator.
*   **Bubble:** `{ ... }` An executable, deferred block of code (closure/thunk).
*   **COLLAPSE:** A contagious, non-lethal null-like state. Operations on `COLLAPSE` yield `COLLAPSE`, but do not instantly destroy the timeline.

## 3. Core Operators

### 3.1. Evaluation & Assignment
*   `:` (Evaluate/Yield): Executes a Bubble or evaluates an expression immediately in the current timeline without forking. `: { ... }` or `: expr`.
*   `<-` (Left Assignment): `target <- source`.
*   `->` (Right Assignment): `source -> target`.

### 3.2. Access & Self
*   `.` (Slot Access): Accesses a slot on an object. Also used for 1-based Array indexing (`arr . 1`).
*   `@` (Self): Refers to the object context in a bound Bubble. Unbound Bubbles yield `void` if `@` is accessed. `void . slot` yields `COLLAPSE`.

### 3.3. Logic & Equality
*   `=` | `==` (Equality): Evaluates to true or false.
*   `!=` | `≠` (Inequality): Evaluates to true or false.
*   `and`, `or`, `not` (Logical): Word operators to prevent symbol collision.

Only `false` and `void` are considered falsy. All other values are truthy, except `COLLAPSE`, which is neither.

### 3.4. Collapse Mechanics
*   `!val` (Is COLLAPSE?): Returns true if `val` is `COLLAPSE`, false otherwise.
*   `?!val : action` (If COLLAPSE, Evaluate): If `val` is COLLAPSE, evaluates `action`.
*   `!!` (Collapse Timeline): Immediately terminates the current timeline.

`COLLAPSE` is neither truthy nor falsy. It is neither equal nor unequal to any value, including itself. All operations on `COLLAPSE` except those mentioned above yield `COLLAPSE`.

### 3.5. Conditionals
*   `? cond : then : else` (Conditional): Lazy evaluation. If `cond` is true, evaluates and yields `then`. If false, evaluates and yields `else`. The `:` acts as a branch delimiter. If `cond` is `COLLAPSE`, the whole expression yields `COLLAPSE`.
*   `? cond : then` (Partial Conditional): If `cond` is false, yields `COLLAPSE`.

## 4. Bubbles and Methods

A Bubble is defined using `{ ... }`. It is a literal, unexecuted block of code, behaving as closure over state at the time of definition.

**Execution Semantics:**
*   A Bubble does not execute just by existing.
*   It executes when invoked via the `:` operator (`: { ... }`), when used as the block for a fork operator (`|- { ... }`), or when called as a method.
*   **Late Binding:** Extracting a method (`obj . method`) yields an unbound Bubble. It carries no object context. Calling an unbound Bubble means `@` is `void`.
*   **Method Call:** `obj . method (args)` executes the Bubble stored in `method`, binding `@` to `obj` for the duration.

**Arguments:**
*   Bubbles can accept arguments using the `|arg1, arg2|` syntax at the start of the block. Example: `{ |x| x . add 2 }`.
*   If a Bubble is called with more arguments than it defines, the extras are discarded.
*   If called with fewer, the missing ones evaluate to `void`.

## 5. Timeline Mechanics: Forking

When a fork operator executes, it uses the current immutable state tree to spawn concurrent timelines. Fork operators evaluate to `void` in the skipping timeline(s) and to last value in executing timeline(s). Data extraction from forks is handled strictly by Observation (`|<`).

### 5.1. Present Forks (The Trunk Model)
Every Bubble scope has exactly one **Trunk** timeline. Fork operators only operate on the Trunk. Sibling timelines ignore subsequent fork operators.

*   `| (A)` (Trunk execution): Trunk executes argument Bubble, forks do not.
*   `|> (A, B, ...)` (Sibling Fork): The Trunk spawns a sibling timeline for each argument Bubble. The Trunk continues executing (skipping the Bubble contents). Siblings execute concurrently.
*   `> (A, B, ...)` (Divergent Fork): Identical to `|>`, but the Trunk immediately collapses after spawning the siblings.
*   `*> (A, B, ...)` (Combinatorial Split): Multiplies timelines. Every active timeline in the current scope splits. For each timeline, one branch skips the arguments, and N branches execute the provided Bubble arguments.

*Note: Sequential `|>` lines create a fan-out because siblings ignore subsequent `|>`.*

### 5.2. Past Forks (The Mark Model)
Chronar maintains a persistent history of state via Marks.

*   `* (name)` (Mark): Takes a snapshot of the current state tree and assigns it to `name`. Syntactic sugar for `name <- *`. Marks are first-class objects and can be stored in variables or object slots.
*   `~ (mark, variable)` (Echo): Yields the value of `variable` as it was at the recorded `mark`. Read-only historical query.
*   `<| (mark, A, ...)` (Past Fork): The Trunk spawns a sibling timeline. The sibling's state is initialized to the `mark`, and then it executes the Bubble(s) A. The Trunk continues from the present.
*   `< (mark, A, ...)` (Past Divergent Fork): Identical to `<|`, but the Trunk immediately collapses after spawning.
*   `<* (mark, A, ...)` (Past Combinatorial Split): Multiplies timelines. Every active timeline in the current scope splits. For each timeline, one branch skips the arguments, and N branches execute the provided Bubble arguments with state initialized to `mark.

## 6. Timeline Mechanics: Synchronization

*   `|<` | `>|<` | `>|` `(expr, ...)` (Merge): The synchronization barrier.
    1.  Any timeline hitting `>|<` evaluates `expr` in its current state, reports the result to the Bubble's scheduler, and pauses.
    2.  The scheduler waits until *all* active sibling timelines within the current Bubble have parked at the `>|<` barrier.
    3.  All parked timelines are terminated. Their local states are destroyed.
    4.  A single new Trunk timeline is born, continuing execution at the line *after* the `>|<`.
    5.  The `>|<` operator yields an Array containing the reported results from all parked timelines.
*   **Implicit Merge:** When a Bubble terminates (reaches its closing `}`), it implicitly performs an `>|<` on its last evaluated expression if one hasn't occurred yet.

## 7. Scoping rules

1. **Variable Assignments are Bubble-Local:** `x <- 10` inside a Bubble does not leak to outer scope, unless `x` already exists in the outer scope.
2. **Slot Assignments are Timeline-Local:** `obj . slot <- 10` modifies the object and implicitly updates the `obj` variable in the current timeline's scope, even if executed inside a Bubble.
3. **Fork Operators are Expressions:** `|> { A }` evaluates to `void` in the skipping timeline, and the return value of `A` in the executing timeline.

These rules mean that this is the correct way to capture the result of a fork:

```chronar
|> { stdlib . http get "url" } -> result
|< result
```

## 8. Globals

*   `stdlib`: The global standard library object. Contains mathematical, string, I/O, and system methods.
*   `true` and `false`: The boolean values. Comparison operators return these.
*   `void`: The absence of a value. Similar to `null` in many languages.

## 9. Objects

Empty object can be created with `[]`. Objects have arbitrary slots (fields, names) that can be filled with values.

Exact mechanics TBD.
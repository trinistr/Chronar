# Example: Concurrent Data Pipeline

# Fetch data from 3 servers concurrently
payload <- | {
    result = void

    # Phase 1: Concurrent Fetch
    |> { stdlib . http get "server1.com/api" -> result }
    |> { stdlib . http get "server2.com/api" -> result }
    | { stdlib . http get "server3.com/api" -> result }

    data <- stdlib . json . parse (result)

    # Synchronize: Wait for the network, harvest 'data'
    # Returns an Array of 3 items (some may be COLLAPSE)
    |< data
}

# Extract the first non-COLLAPSE payload
payload . compact . first -> valid data

# If everything failed, collapse the main program
?!valid data : !! 

# Phase 2: Run heavy math simulations concurrently on the valid data
scores <- | {
    score = void

    valid data <- valid data . to_number . clamp 0, 1000
    |> { mylib . algo alpha (valid data) -> score }
    | { mylib . algo beta (valid data) -> score }

    # Observe the scores
    |< score
}

# We have an Array of scores. Get the highest.
best score <- scores . compact . max

stdlib . print (best score)
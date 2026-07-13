# frozen_string_literal: true

require "yaml"

RSpec.describe Chronar::Parser do
  describe ".parse" do
    let(:program) { <<~CHRONAR }
      stdlib . print "Hellow!"
      |> { !! }
    CHRONAR

    it "delegates to #parse" do
      expect(described_class.parse(program)).to eq described_class.new.parse(program)
    end
  end

  describe "#raw_parse" do
    subject(:parsed_tree) { described_class.new.raw_parse(program) }

    context "with an empty program" do
      let(:program) { "" }

      it "returns an empty `expression` as the only node in the program" do
        expect(parsed_tree).to eq(a_program: { expression: "" })
      end
    end

    context "with a program containing only comments and blank lines" do
      let(:program) { <<~CHRONAR }
        #!/usr/bin/env chronar
        # My first program

        # Doesn't work yet though :'(
        # reality . rewind
      CHRONAR

      it "returns an `expression` containing comments" do
        expect(parsed_tree).to eq(
          a_program: {
            expression: [
              { comment: { content: "!/usr/bin/env chronar" } },
              { comment: { content: "My first program" } },
              { comment: { content: "Doesn't work yet though :'(" } },
              { comment: { content: "reality . rewind" } },
            ],
          }
        )
      end
    end

    context "with a program splitting timeline and assigning results" do
      let(:program) { <<~CHRONAR }
        #!/usr/bin/env chronar

        |> {
          |> { true } -> control
          stdlib . print line (control)
          |< control # observe `control` state
        }
        > {
          line <- stdlib . get line ()
          ?!line : "dead input!"
        }
      CHRONAR

      it "returns a parsed tree" do
        expect(parsed_tree).to eq(
          a_program: {
            expression: [
              { comment: { content: "!/usr/bin/env chronar" } },
              {
                statement: {
                  operator: {
                    trunk_branch: "|>",
                    argument_list: {
                      bubble: {
                        expression: [
                          {
                            statement: {
                              assignment: {
                                target: { identifier: "control" },
                                value: {
                                  operator: {
                                    trunk_branch: "|>",
                                    argument_list: {
                                      bubble: {
                                        expression: {
                                          statement: { literal: { true: "true" } }, # rubocop:disable Lint/BooleanSymbol
                                        },
                                      },
                                    },
                                  },
                                },
                              },
                            },
                          },
                          {
                            statement: {
                              method_call: {
                                slot: {
                                  root: { identifier: "stdlib" },
                                  path: [{ identifier: "print line" }],
                                },
                                argument_list: { statement: { identifier: "control" } },
                              },
                            },
                          },
                          {
                            statement: {
                              operator: {
                                merge: "|<",
                                argument_list: { identifier: "control" },
                              },
                            },
                          },
                          { comment: { content: "observe `control` state" } },
                        ],
                      },
                    },
                  },
                },
              },
              {
                statement: {
                  operator: {
                    branch: ">",
                    argument_list: {
                      bubble: {
                        expression: [
                          {
                            statement: {
                              assignment: {
                                target: { identifier: "line" },
                                value: {
                                  statement: {
                                    method_call: {
                                      slot: {
                                        root: { identifier: "stdlib" },
                                        path: [{ identifier: "get line" }],
                                      },
                                      argument_list: "()",
                                    },
                                  },
                                },
                              },
                            },
                          },
                          {
                            statement: {
                              conditional: {
                                condition: {
                                  statement: {
                                    operator: {
                                      not_collapse: "!",
                                      argument_list: { statement: { identifier: "line" } },
                                    },
                                  },
                                },
                                then: {
                                  statement: {
                                    literal: { string: { content: "dead input!" } },
                                  },
                                },
                                else: nil,
                              },
                            },
                          },
                        ],
                      },
                    },
                  },
                },
              },
            ],
          }
        )
      end
    end
  end
end

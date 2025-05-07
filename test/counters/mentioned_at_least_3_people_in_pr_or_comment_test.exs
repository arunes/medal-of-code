defmodule Moc.Tests.Counters.MentionedAtLeast3PeopleInPROrCommentTest do
  use ExUnit.Case
  alias Moc.Scoring.Counters.MentionedAtLeast3PeopleInPROrComment
  alias Moc.Scoring.Counters.Type

  test "returns an empty list when there are no comments or PR description" do
    input = %Type.Input{
      comments: [],
      description: "",
      created_by_id: "11111111-1111-1111-1111-111111111111"
    }

    assert MentionedAtLeast3PeopleInPROrComment.count(input, nil) == []
  end

  test "returns an empty list when there are less than 3 mentions in PR description" do
    input = %Type.Input{
      comments: [],
      description:
        "@<12345678-1234-1234-1234-123456789012> @<23456789-2345-2345-2345-234567890123>",
      created_by_id: "11111111-1111-1111-1111-111111111111"
    }

    assert MentionedAtLeast3PeopleInPROrComment.count(input, nil) == []
  end

  test "returns a contributor with a count of 1 when there are at least 3 mentions in PR description" do
    input = %Type.Input{
      comments: [],
      description:
        "@<12345678-1234-1234-1234-123456789012> @<23456789-2345-2345-2345-234567890123> @<34567890-3456-3456-3456-345678901234>",
      created_by_id: "11111111-1111-1111-1111-111111111111"
    }

    assert MentionedAtLeast3PeopleInPROrComment.count(input, nil) == [
             %{contributor_id: "11111111-1111-1111-1111-111111111111", count: 1}
           ]
  end

  test "returns an empty list when there are less than 3 mentions in comments" do
    input = %Type.Input{
      comments: [
        %{
          content:
            "@<12345678-1234-1234-1234-123456789012> @<23456789-2345-2345-2345-234567890123>",
          created_by_id: "22222222-2222-2222-2222-222222222222",
          comment_type: :text
        }
      ],
      description: "",
      created_by_id: "11111111-1111-1111-1111-111111111111"
    }

    assert MentionedAtLeast3PeopleInPROrComment.count(input, nil) == []
  end

  test "returns a contributor with a count of 1 when there are at least 3 mentions in a text comment" do
    input = %Type.Input{
      comments: [
        %{
          content:
            "@<12345678-1234-1234-1234-123456789012> @<23456789-2345-2345-2345-234567890123> @<34567890-3456-3456-3456-345678901234>",
          created_by_id: "22222222-2222-2222-2222-222222222222",
          comment_type: :text
        }
      ],
      description: "",
      created_by_id: "11111111-1111-1111-1111-111111111111"
    }

    assert MentionedAtLeast3PeopleInPROrComment.count(input, nil) == [
             %{contributor_id: "22222222-2222-2222-2222-222222222222", count: 1}
           ]
  end

  test "ignores non-text comments" do
    input = %Type.Input{
      comments: [
        %{
          content:
            "@<12345678-1234-1234-1234-123456789012> @<23456789-2345-2345-2345-234567890123> @<34567890-3456-3456-3456-345678901234>",
          created_by_id: "22222222-2222-2222-2222-222222222222",
          comment_type: :system
        }
      ],
      description: "",
      created_by_id: "11111111-1111-1111-1111-111111111111"
    }

    assert MentionedAtLeast3PeopleInPROrComment.count(input, nil) == []
  end

  test "returns multiple contributors with a count of 1 when there are at least 3 mentions in multiple comments" do
    input = %Type.Input{
      comments: [
        %{
          content:
            "@<12345678-1234-1234-1234-123456789012> @<23456789-2345-2345-2345-234567890123> @<34567890-3456-3456-3456-345678901234>",
          created_by_id: "22222222-2222-2222-2222-222222222222",
          comment_type: :text
        },
        %{
          content:
            "@<45678901-4567-4567-4567-456789012345> @<56789012-5678-5678-5678-567890123456> @<67890123-6789-6789-6789-678901234567>",
          created_by_id: "33333333-3333-3333-3333-333333333333",
          comment_type: :text
        }
      ],
      description: "",
      created_by_id: "11111111-1111-1111-1111-111111111111"
    }

    assert MentionedAtLeast3PeopleInPROrComment.count(input, nil) == [
             %{contributor_id: "22222222-2222-2222-2222-222222222222", count: 1},
             %{contributor_id: "33333333-3333-3333-3333-333333333333", count: 1}
           ]
  end
end

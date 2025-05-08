defmodule Moc.Seeds.CountersAndMedals do
  def run do
    Moc.Repo.insert!(%Moc.Scoring.Counter{
      key: "commentedWithQuestion",
      xp: 3.0,
      display_order: 111,
      is_main_counter: false,
      main_description: nil,
      is_personal_counter: false,
      personal_description: "Commented on a PR with a question.",
      category: "Comment",
      affinity: :neutral,
      charisma: 0.0,
      constitution: 0.0,
      dexterity: 0.0,
      wisdom: 0.0,
      medals: [
        %Moc.Scoring.Medal{
          name: "Curious Cat",
          description: "Ask 100 questions in comments.",
          count_to_award: 100,
          affinity: :light,
          lore:
            "In the shadowed alcoves of the repository, there roamed a seeker—a Curious Cat. With eyes wide as moonlit orbs, they pounced upon PRs, unraveling threads of code with a hundred questions. Each query, a whispered riddle to the digital guardians."
        }
      ]
    })

    Moc.Repo.insert!(%Moc.Scoring.Counter{
      key: "commentedAllUppercase",
      xp: 1.0,
      display_order: 111,
      is_main_counter: false,
      main_description: nil,
      is_personal_counter: false,
      personal_description: "Commented on a PR with all upper case.",
      category: "Comment",
      affinity: :dark,
      charisma: 0.0,
      constitution: 0.0,
      dexterity: 0.0,
      wisdom: 0.0,
      medals: [
        %Moc.Scoring.Medal{
          name: "LOUD AND PROUD",
          description: "Comment on a PR with all upper case.",
          count_to_award: 1,
          affinity: :dark,
          lore:
            "Behold the raucous herald, the one who wielded caps like a battle cry! Their comment echoed across the pull request, a tempest of uppercase defiance. The codebase trembled, and even the compiler dared not correct them."
        }
      ]
    })

    Moc.Repo.insert!(%Moc.Scoring.Counter{
      key: "commented25TimesOnSamePR",
      xp: 55.0,
      display_order: 111,
      is_main_counter: false,
      main_description: nil,
      is_personal_counter: false,
      personal_description: "Commented 25 times on same PR.",
      category: "Comment",
      affinity: :light,
      charisma: 0.0,
      constitution: 0.0,
      dexterity: 0.0,
      wisdom: 1.0,
      medals: [
        %Moc.Scoring.Medal{
          name: "Feedback Fanatic",
          description: "Leave at least 25 comments on a single PR.",
          count_to_award: 1,
          affinity: :light,
          lore:
            "The Inkwell Sage, ink-stained fingers dancing, wove a tapestry of commentary. Twenty-five threads they spun, each comment a thread in the grand design. ‘Constructive,’ they murmured, ‘is the heartbeat of progress.’"
        }
      ]
    })

    Moc.Repo.insert!(%Moc.Scoring.Counter{
      key: "prsCompleted",
      xp: 100.0,
      display_order: 1,
      is_main_counter: true,
      main_description: "PRs completed.",
      is_personal_counter: true,
      personal_description: "Completed a PR.",
      category: "Pull Request",
      affinity: :light,
      charisma: 0.0,
      constitution: 1.0,
      dexterity: 0.0,
      wisdom: 1.0,
      medals: [
        %Moc.Scoring.Medal{
          name: "100s Club",
          description: "Complete 100 PRs.",
          count_to_award: 100,
          affinity: :light,
          lore:
            "The Centurion Coder, their fingers a blur, crossed the threshold of a hundred PRs. ‘Perseverance,’ they proclaimed, ‘is the mark of legends.'"
        }
      ]
    })

    Moc.Repo.insert!(%Moc.Scoring.Counter{
      key: "totalWordsCommentedOnPR",
      xp: 0.23,
      display_order: 9,
      is_main_counter: true,
      main_description: "Total words commented.",
      is_personal_counter: true,
      personal_description: "Total words commented on a PR.",
      category: "Comment",
      affinity: :neutral,
      charisma: 0.0,
      constitution: 0.0,
      dexterity: 0.0,
      wisdom: 0.0,
      medals: [
        %Moc.Scoring.Medal{
          name: "Could Have Been a Book",
          description: "Reach 25,000 words in all comments.",
          count_to_award: 25000,
          affinity: :light,
          lore:
            "The Verbose Virtuoso, quill in hand, penned a saga within the comments. ‘Twenty-five thousand words,’ they mused, ‘a tome of knowledge in the code’s margins.’"
        }
      ]
    })

    Moc.Repo.insert!(%Moc.Scoring.Counter{
      key: "commented5TimesOnSamePRIn5Minutes",
      xp: 36.0,
      display_order: 111,
      is_main_counter: false,
      main_description: nil,
      is_personal_counter: false,
      personal_description: "Commented 5 times on same PR in 5 minutes.",
      category: "Comment",
      affinity: :neutral,
      charisma: 0.0,
      constitution: 0.0,
      dexterity: 10.0,
      wisdom: 1.0,
      medals: [
        %Moc.Scoring.Medal{
          name: "Instant Insight",
          description: "On 10 PRs, leave 5 comments under 5 minutes.",
          count_to_award: 10,
          affinity: :light,
          lore:
            "...insight flashing like lightning, graced ten PRs with quintuple comments. ‘In brevity,’ they declared, ‘lies the spark of understanding.’"
        }
      ]
    })

    Moc.Repo.insert!(%Moc.Scoring.Counter{
      key: "commentsRepliedLessThan5Minutes",
      xp: 6.0,
      display_order: 111,
      is_main_counter: false,
      main_description: nil,
      is_personal_counter: false,
      personal_description: "Reply a comment in less then 5 minutes.",
      category: "Comment",
      affinity: :light,
      charisma: 0.0,
      constitution: 0.0,
      dexterity: 10.0,
      wisdom: 0.0,
      medals: [
        %Moc.Scoring.Medal{
          name: "Rapid Responder",
          description: "On 10 PRs, reply comments under 5 minutes.",
          count_to_award: 10,
          affinity: :light,
          lore:
            "Replies swift as arrows, met ten PRs with timely ripostes. ‘Speed,’ they intoned, ‘is the ally of clarity.’"
        }
      ]
    })

    Moc.Repo.insert!(%Moc.Scoring.Counter{
      key: "totalLettersCommentedOnPR",
      xp: 0.11,
      display_order: 111,
      is_main_counter: false,
      main_description: nil,
      is_personal_counter: false,
      personal_description: "Total letters commented on a PR.",
      category: "Comment",
      affinity: :neutral,
      charisma: 0.0,
      constitution: 0.0,
      dexterity: 0.0,
      wisdom: 0.0,
      medals: [
        %Moc.Scoring.Medal{
          name: "Log.Verbose",
          description: "Reach 100k letters in all comments.",
          count_to_award: 100_000,
          affinity: :light,
          lore:
            "The Loquacious Logger, letters flowing like a river, reached a deluge of 100k. ‘Let the comments,’ they laughed, ‘be as bountiful as the code itself.’"
        }
      ]
    })

    Moc.Repo.insert!(%Moc.Scoring.Counter{
      key: "prsApproved",
      xp: 50.0,
      display_order: 3,
      is_main_counter: false,
      main_description: nil,
      is_personal_counter: true,
      personal_description: "Approved a PR created by others.",
      category: "Pull Request",
      affinity: :light,
      charisma: 0.0,
      constitution: 0.0,
      dexterity: 0.0,
      wisdom: 0.0,
      medals: [
        %Moc.Scoring.Medal{
          name: "Stamped",
          description: "Approve 100 PRs.",
          count_to_award: 100,
          affinity: :light,
          lore:
            "The Sealbearer, stamp in hand, marked a hundred PRs with approval’s kiss. ‘Each stamp,’ they smiled, ‘a testament to code’s triumph.’"
        }
      ]
    })

    Moc.Repo.insert!(%Moc.Scoring.Counter{
      key: "prsApprovedWithSuggestions",
      xp: 60.0,
      display_order: 5,
      is_main_counter: false,
      main_description: nil,
      is_personal_counter: true,
      personal_description: "Approved a PR created by others with suggestions.",
      category: "Pull Request",
      affinity: :neutral,
      charisma: 0.0,
      constitution: 0.0,
      dexterity: 0.0,
      wisdom: 0.0,
      medals: [
        %Moc.Scoring.Medal{
          name: "Critic",
          description: "Approve 100 PRs with suggestions.",
          count_to_award: 100,
          affinity: :light,
          lore:
            "Suggestions at the ready, guided a hundred PRs with wisdom’s touch. ‘To improve,’ they counseled, ‘is to love the code.’"
        }
      ]
    })

    Moc.Repo.insert!(%Moc.Scoring.Counter{
      key: "commentsReplied",
      xp: 1.0,
      display_order: 111,
      is_main_counter: false,
      main_description: nil,
      is_personal_counter: false,
      personal_description: "Reply a comment.",
      category: "Comment",
      affinity: :light,
      charisma: 0.0,
      constitution: 0.0,
      dexterity: 0.0,
      wisdom: 0.0,
      medals: [
        %Moc.Scoring.Medal{
          name: "Conversationalist",
          description: "Reply total of 100 comments.",
          count_to_award: 100,
          affinity: :light,
          lore:
            "A hundred replies danced through the threads, each parry and thrust from the sharpening minds."
        }
      ]
    })

    Moc.Repo.insert!(%Moc.Scoring.Counter{
      key: "optionalReviewersAdded",
      xp: 10.0,
      display_order: 111,
      is_main_counter: false,
      main_description: nil,
      is_personal_counter: false,
      personal_description: "Added a optional reviewer to a PR.",
      category: "Review",
      affinity: :neutral,
      charisma: 0.0,
      constitution: 0.0,
      dexterity: 0.0,
      wisdom: 0.0,
      medals: [
        %Moc.Scoring.Medal{
          name: "More the Merrier",
          description: "Add total of 100 optional reviewers to your PRs.",
          count_to_award: 100,
          affinity: :neutral,
          lore:
            "The Convivial Convener, ever inclusive, welcomed a hundred optional reviewers to the feast of PRs. ‘Together,’ they cheered, ‘we raise the code.’"
        }
      ]
    })

    Moc.Repo.insert!(%Moc.Scoring.Counter{
      key: "requiredReviewersAdded",
      xp: 30.0,
      display_order: 111,
      is_main_counter: false,
      main_description: nil,
      is_personal_counter: false,
      personal_description: "Added a required reviewer to a PR.",
      category: "Review",
      affinity: :neutral,
      charisma: 0.0,
      constitution: 0.0,
      dexterity: 0.0,
      wisdom: 1.0,
      medals: [
        %Moc.Scoring.Medal{
          name: "Recruiter",
          description: "Add total of 100 required reviewers to your PRs.",
          count_to_award: 100,
          affinity: :light,
          lore:
            "Destiny’s code called forth a hundred required reviewers, each enlisted by the keen-eyed scout."
        }
      ]
    })

    Moc.Repo.insert!(%Moc.Scoring.Counter{
      key: "prsAbandoned",
      xp: 50.0,
      display_order: 2,
      is_main_counter: true,
      main_description: "PRs abandoned.",
      is_personal_counter: true,
      personal_description: "Abandon a PR.",
      category: "Pull Request",
      affinity: :dark,
      charisma: 0.0,
      constitution: 5.0,
      dexterity: 0.0,
      wisdom: 1.0,
      medals: [
        %Moc.Scoring.Medal{
          name: "Escape Artist",
          description: "Abandon 10 PRs.",
          count_to_award: 10,
          affinity: :dark,
          lore:
            "In the art of vanishing, none matched the Elusive Evader, slipping away from ten PRs like mist at dawn."
        }
      ]
    })

    Moc.Repo.insert!(%Moc.Scoring.Counter{
      key: "commentedOnPR",
      xp: 10.0,
      display_order: 8,
      is_main_counter: true,
      main_description: "Total comments.",
      is_personal_counter: true,
      personal_description: "Commented on a PR.",
      category: "Comment",
      affinity: :light,
      charisma: 0.0,
      constitution: 0.0,
      dexterity: 0.0,
      wisdom: 0.0,
      medals: [
        %Moc.Scoring.Medal{
          name: "Thousand Thoughts",
          description: "Leave 1,000 comments.",
          count_to_award: 1000,
          affinity: :light,
          lore: "The code whisper secrets to those who dare to listen."
        }
      ]
    })

    Moc.Repo.insert!(%Moc.Scoring.Counter{
      key: "prsWithAPicture",
      xp: 18.0,
      display_order: 111,
      is_main_counter: false,
      main_description: nil,
      is_personal_counter: false,
      personal_description: "Added a picture to PR description.",
      category: "Pull Request",
      affinity: :light,
      charisma: 5.0,
      constitution: 0.0,
      dexterity: 0.0,
      wisdom: 0.0,
      medals: [
        %Moc.Scoring.Medal{
          name: "Worth a Thousand Words",
          description: "Create 10 PR with a picture in description..",
          count_to_award: 10,
          affinity: :light,
          lore:
            "The Pictomancer wove images into their PRs. Ten times, they painted with pixels, revealing the code’s essence. ‘Behold,’ they whispered, ‘a thousand words.’"
        }
      ]
    })

    Moc.Repo.insert!(%Moc.Scoring.Counter{
      key: "gotApprovedByAllReviewersAtLeast5",
      xp: 71.0,
      display_order: 111,
      is_main_counter: false,
      main_description: nil,
      is_personal_counter: false,
      personal_description: "Created PR got approved by all reviewers. (At least 5 reviewers).",
      category: "Review",
      affinity: :neutral,
      charisma: 5.0,
      constitution: 0.0,
      dexterity: 0.0,
      wisdom: 0.0,
      medals: [
        %Moc.Scoring.Medal{
          name: "People's Choice",
          description: "Get approvals from all reviewers with at least 5 reviewers.",
          count_to_award: 1,
          affinity: :light,
          lore:
            "The Consensus Seeker sought harmony among the council. Five reviewers, five nods of approval. ‘Unity,’ they whispered, ‘is the true strength.’"
        }
      ]
    })

    Moc.Repo.insert!(%Moc.Scoring.Counter{
      key: "commentLiked3TimesByOthers",
      xp: 13.0,
      display_order: 111,
      is_main_counter: false,
      main_description: nil,
      is_personal_counter: false,
      personal_description: "Got 3 likes on a comment made.",
      category: "Comment",
      affinity: :neutral,
      charisma: 5.0,
      constitution: 0.0,
      dexterity: 0.0,
      wisdom: 0.0,
      medals: [
        %Moc.Scoring.Medal{
          name: "Talk of the Town",
          description: "Get at least 3 likes on a comment you made.",
          count_to_award: 1,
          affinity: :light,
          lore:
            "The Gossiper’s Comment danced like fireflies in the twilight. ‘Did you hear?’ they chattered. ‘Three likes! The comment shall be sung in taverns.’"
        }
      ]
    })

    Moc.Repo.insert!(%Moc.Scoring.Counter{
      key: "commentsRepliedAtLeast3Others",
      xp: 17.0,
      display_order: 111,
      is_main_counter: false,
      main_description: nil,
      is_personal_counter: false,
      personal_description: "Made a comment replied by 3 different people.",
      category: "Comment",
      affinity: :neutral,
      charisma: 1.0,
      constitution: 0.0,
      dexterity: 0.0,
      wisdom: 0.0,
      medals: [
        %Moc.Scoring.Medal{
          name: "Conversation Starter",
          description: "Have 3 people in same PR reply to your comment.",
          count_to_award: 1,
          affinity: :light,
          lore:
            "Three voices entwined in the PR’s sacred thread. The Bard of Comments sang tales of logic, the Oracle of Replies pondered, and the Jester quipped. Thus, the code danced"
        }
      ]
    })

    Moc.Repo.insert!(%Moc.Scoring.Counter{
      key: "commentsRepliedLessThanAMinute",
      xp: 24.0,
      display_order: 111,
      is_main_counter: false,
      main_description: nil,
      is_personal_counter: false,
      personal_description: "Reply a comment in less then a minute.",
      category: "Comment",
      affinity: :light,
      charisma: 0.0,
      constitution: 0.0,
      dexterity: 15.0,
      wisdom: 0.0,
      medals: [
        %Moc.Scoring.Medal{
          name: "Fast Finger",
          description: "Reply 10 comments in less than a minute.",
          count_to_award: 10,
          affinity: :light,
          lore:
            "The Swift Replier danced on the edge of time. In sixty seconds, they wove replies like spider silk. ‘Patience,’ they whispered, ‘is for the slow."
        }
      ]
    })

    Moc.Repo.insert!(%Moc.Scoring.Counter{
      key: "prsRejectedByOthers",
      xp: 1.0,
      display_order: 111,
      is_main_counter: false,
      main_description: nil,
      is_personal_counter: false,
      personal_description: "Got a rejection on a PR.",
      category: "Review",
      affinity: :dark,
      charisma: 0.0,
      constitution: 5.0,
      dexterity: 0.0,
      wisdom: 10.0,
      medals: [
        %Moc.Scoring.Medal{
          name: "Dissed",
          description: "Get your PR rejected.",
          count_to_award: 1,
          affinity: :dark,
          lore:
            "The Rejected Knight, crestfallen, sheathed their pull request. ‘Denied,’ echoed the stone walls. But in the quiet of the night, they vowed to return, stronger, wiser, and with better indentation."
        }
      ]
    })

    Moc.Repo.insert!(%Moc.Scoring.Counter{
      key: "prsCompletedWithNoApprovals",
      xp: 0.0,
      display_order: 111,
      is_main_counter: false,
      main_description: nil,
      is_personal_counter: false,
      personal_description: "Completed a PR without getting any approvals.",
      category: "Pull Request",
      affinity: :dark,
      charisma: 0.0,
      constitution: 0.0,
      dexterity: 0.0,
      wisdom: 0.0,
      medals: [
        %Moc.Scoring.Medal{
          name: "Outlaw",
          description: "Complete a PR without getting any approvals.",
          count_to_award: 1,
          affinity: :dark,
          lore:
            "The Rogue Coder rode into the repository, guns blazing. No approvals, no mercy. ‘Lone wolf,’ they grinned, ‘but the code shall ride free.’"
        }
      ]
    })

    Moc.Repo.insert!(%Moc.Scoring.Counter{
      key: "commentsLiked",
      xp: 3.0,
      display_order: 11,
      is_main_counter: true,
      main_description: "Comments liked.",
      is_personal_counter: true,
      personal_description: "Liked a comment.",
      category: "Comment",
      affinity: :neutral,
      charisma: 1.0,
      constitution: 0.0,
      dexterity: 0.0,
      wisdom: 0.0,
      medals: [
        %Moc.Scoring.Medal{
          name: "Bighearted",
          description: "Like total of 50 comments.",
          count_to_award: 50,
          affinity: :light,
          lore:
            "The Comment Sage, known to all as ‘Thumbs Up,’ wandered the comment threads. With each click, hearts bloomed like wildflowers. Fifty times, they bestowed their silent blessings, and the codebase thrived."
        }
      ]
    })

    Moc.Repo.insert!(%Moc.Scoring.Counter{
      key: "commentedWithEmoji",
      xp: 11.0,
      display_order: 111,
      is_main_counter: false,
      main_description: nil,
      is_personal_counter: false,
      personal_description: "Commented on a PR with an emoji.",
      category: "Comment",
      affinity: :neutral,
      charisma: 1.0,
      constitution: 0.0,
      dexterity: 0.0,
      wisdom: 0.0,
      medals: [
        %Moc.Scoring.Medal{
          name: "Emojinator",
          description: "Comment a PR with an emoji.",
          count_to_award: 1,
          affinity: :light,
          lore:
            "The Glyph Alchemist inscribed the PR with arcane symbols. The code stirred, infused with cosmic approval. The repository nodded, ‘Well played, Emojinator.’"
        }
      ]
    })

    Moc.Repo.insert!(%Moc.Scoring.Counter{
      key: "prsCompletedWithNoCommentsAndAtLeast3Approvals",
      xp: 62.0,
      display_order: 111,
      is_main_counter: false,
      main_description: nil,
      is_personal_counter: false,
      personal_description: "Completed a PR that has at least 3 approvals and no comments.",
      category: "Pull Request",
      affinity: :neutral,
      charisma: 5.0,
      constitution: 0.0,
      dexterity: 0.0,
      wisdom: 0.0,
      medals: [
        %Moc.Scoring.Medal{
          name: "Flawless",
          description: "Complete a PR with no comments and at least 3 approvals.",
          count_to_award: 1,
          affinity: :light,
          lore:
            "The Whispering Wind carried whispers of a flawless PR. No comments marred its surface, yet three approvals shimmered like moonlit dewdrops. The Repository Keeper nodded, ‘Elegance.’"
        }
      ]
    })

    Moc.Repo.insert!(%Moc.Scoring.Counter{
      key: "commentedAsLGTM",
      xp: 6.0,
      display_order: 111,
      is_main_counter: false,
      main_description: nil,
      is_personal_counter: false,
      personal_description: "Commented on a PR as LGTM.",
      category: "Comment",
      affinity: :neutral,
      charisma: 0.0,
      constitution: 0.0,
      dexterity: 0.0,
      wisdom: 0.0,
      medals: [
        %Moc.Scoring.Medal{
          name: "LGTM!",
          description: "Comment in a PR as lgmt.",
          count_to_award: 1,
          affinity: :neutral,
          lore:
            "The Abbreviator, master of brevity, cast their spell: ‘LGTM!’ The PR rejoiced, for in those four letters lay cosmic approval."
        }
      ]
    })

    Moc.Repo.insert!(%Moc.Scoring.Counter{
      key: "commented10TimesOnSamePR",
      xp: 33.0,
      display_order: 111,
      is_main_counter: false,
      main_description: nil,
      is_personal_counter: false,
      personal_description: "Commented 10 times on same PR.",
      category: "Comment",
      affinity: :light,
      charisma: 0.0,
      constitution: 0.0,
      dexterity: 0.0,
      wisdom: 1.0,
      medals: [
        %Moc.Scoring.Medal{
          name: "Feedback Enthusiast",
          description: "Leave at least 10 comments on a single PR.",
          count_to_award: 1,
          affinity: :light,
          lore:
            "The Inkwell Sage dipped their quill in wisdom. Ten comments flowed, nourishing the code like rain on parched earth. ‘Constructive,’ they murmured, ‘is the key."
        }
      ]
    })

    Moc.Repo.insert!(%Moc.Scoring.Counter{
      key: "prsWithAtLeast10Reviewers",
      xp: 28.0,
      display_order: 111,
      is_main_counter: false,
      main_description: nil,
      is_personal_counter: false,
      personal_description: "Number of PRs created with at least 10 reviewers.",
      category: "Pull Request",
      affinity: :light,
      charisma: 0.0,
      constitution: 0.0,
      dexterity: 0.0,
      wisdom: 0.0,
      medals: [
        %Moc.Scoring.Medal{
          name: "Big Party Planner",
          description: "Add at least 10 reviewers to your PR.",
          count_to_award: 1,
          affinity: :light,
          lore:
            "In the Great Hall of Pull Requests, amidst the clatter of keyboards, there stood a mighty architect. With a flourish, they summoned reviewers from distant realms, binding their fate to the code. And lo, the PR was adorned with stars, like lanterns in a jubilant feast."
        }
      ]
    })

    Moc.Repo.insert!(%Moc.Scoring.Counter{
      key: "prsCompletedIn10Minutes",
      xp: 38.0,
      display_order: 111,
      is_main_counter: false,
      main_description: nil,
      is_personal_counter: false,
      personal_description: "Completed a PR within 10 minutes of its creation.",
      category: "Pull Request",
      affinity: :neutral,
      charisma: 0.0,
      constitution: 0.0,
      dexterity: 20.0,
      wisdom: 0.0,
      medals: [
        %Moc.Scoring.Medal{
          name: "Blink of an Eye",
          description: "Complete a PR within 10 minutes after its published.",
          count_to_award: 1,
          affinity: :light,
          lore:
            "Swift as a startled deer, the PR Whisperer emerged from the shadows. Ten minutes hence, the code was embraced by the repository, leaving no trace but a whisper: ‘Did you see that? Blink, and it was done!’."
        }
      ]
    })

    Moc.Repo.insert!(%Moc.Scoring.Counter{
      key: "commentedOnPRAfterCompleted",
      xp: 5.0,
      display_order: 111,
      is_main_counter: false,
      main_description: nil,
      is_personal_counter: false,
      personal_description: "Commented on a PR after completed.",
      category: "Comment",
      affinity: :neutral,
      charisma: 0.0,
      constitution: 5.0,
      dexterity: 0.0,
      wisdom: 0.0,
      medals: [
        %Moc.Scoring.Medal{
          name: "Fashionably Late",
          description: "Comment on a PR after its completion.",
          count_to_award: 1,
          affinity: :neutral,
          lore:
            "The Midnight Commentator emerged when the moon hung low. ‘Ah,’ they mused, ‘the PR is complete, but my words shall linger like echoes in a forgotten library."
        }
      ]
    })

    Moc.Repo.insert!(%Moc.Scoring.Counter{
      key: "commented15TimesOnSamePR",
      xp: 44.0,
      display_order: 111,
      is_main_counter: false,
      main_description: nil,
      is_personal_counter: false,
      personal_description: "Commented 15 times on same PR.",
      category: "Comment",
      affinity: :light,
      charisma: 0.0,
      constitution: 0.0,
      dexterity: 0.0,
      wisdom: 1.0,
      medals: [
        %Moc.Scoring.Medal{
          name: "Feedback Zealot",
          description: "Leave at least 15 comments on a single PR.",
          count_to_award: 1,
          affinity: :light,
          lore:
            "The Zealous Scribe, eyes ablaze, inscribed their fervor upon the PR. Fifteen scrolls of wisdom, each comment a rune of enlightenment. ‘More,’ they whispered, ‘for the code hungers.’"
        }
      ]
    })

    Moc.Repo.insert!(%Moc.Scoring.Counter{
      key: "prsCompletedWithNoReviewers",
      xp: 0.0,
      display_order: 111,
      is_main_counter: false,
      main_description: nil,
      is_personal_counter: false,
      personal_description: "Completed a PR without adding any reviewers.",
      category: "Pull Request",
      affinity: :dark,
      charisma: 0.0,
      constitution: 0.0,
      dexterity: 0.0,
      wisdom: 0.0,
      medals: [
        %Moc.Scoring.Medal{
          name: "Judge, Jury and Executioner",
          description: "Complete 5 PRs without adding any reviewers.",
          count_to_award: 5,
          affinity: :dark,
          lore:
            "Silent as a shadow, the Lone Reviewer emerged. No peers by their side, no mercy in their gaze. The PR stood trial, and with a single click, its fate was sealed."
        }
      ]
    })

    Moc.Repo.insert!(%Moc.Scoring.Counter{
      key: "commentedOwnPRBeforeOthers",
      xp: 9.0,
      display_order: 111,
      is_main_counter: false,
      main_description: nil,
      is_personal_counter: false,
      personal_description: "Commented on own PR before anyone else.",
      category: "Comment",
      affinity: :neutral,
      charisma: 0.0,
      constitution: 0.0,
      dexterity: 6.0,
      wisdom: 0.0,
      medals: [
        %Moc.Scoring.Medal{
          name: "Let me Explain",
          description: "Comment 10 times on your own PRs before anyone else.",
          count_to_award: 10,
          affinity: :light,
          lore:
            "The Self-Explainer, ever eager, penned manifestos on their own PRs. ‘Before you ask,’ they wrote, ‘let me elucidate.’ The code nodded, bemused."
        }
      ]
    })

    Moc.Repo.insert!(%Moc.Scoring.Counter{
      key: "ownPRsApproved",
      xp: 2.0,
      display_order: 111,
      is_main_counter: false,
      main_description: nil,
      is_personal_counter: false,
      personal_description: "Approved own PR.",
      category: "Review",
      affinity: :dark,
      charisma: 0.0,
      constitution: 0.0,
      dexterity: 0.0,
      wisdom: 0.0,
      medals: [
        %Moc.Scoring.Medal{
          name: "My Precious",
          description: "Approve 10 of your own PRs.",
          count_to_award: 10,
          affinity: :dark,
          lore:
            "In the Halls of Self-Validation, the PR Ringbearer clutched their precious code. ‘Approve,’ they whispered, ‘for it is mine."
        }
      ]
    })

    Moc.Repo.insert!(%Moc.Scoring.Counter{
      key: "samePRVotedAtLeast10Times",
      xp: 112.0,
      display_order: 111,
      is_main_counter: false,
      main_description: nil,
      is_personal_counter: false,
      personal_description: "Voted on same PR at least 10 times.",
      category: "Review",
      affinity: :neutral,
      charisma: 0.0,
      constitution: 20.0,
      dexterity: 0.0,
      wisdom: 0.0,
      medals: [
        %Moc.Scoring.Medal{
          name: "Insanity",
          description: "Vote on a same PR at least 10 times.",
          count_to_award: 1,
          affinity: :light,
          lore:
            "In the shadowed catacombs of the Git Crypt, the mad alchemist, Professor Hexadecimal, cackled. His eyes glowed like rogue LEDs. Ten times he pressed the mystical button on a single pull request. The repository quivered, and the codebase whispered secrets only the insane could comprehend."
        }
      ]
    })

    Moc.Repo.insert!(%Moc.Scoring.Counter{
      key: "mergeConflictsResolved",
      xp: 14.0,
      display_order: 13,
      is_main_counter: true,
      main_description: "Number of merge conflicts resolved.",
      is_personal_counter: true,
      personal_description: "Number of merge conflicts resolved.",
      category: "Conflict",
      affinity: :light,
      charisma: 0.0,
      constitution: 5.0,
      dexterity: 0.0,
      wisdom: 0.0,
      medals: [
        %Moc.Scoring.Medal{
          name: "Fix-it Felix",
          description: "Fix 10 merge conflicts.",
          count_to_award: 10,
          affinity: :light,
          lore:
            "In the Forge of Clashing Realms, Fix-it Felix swung his digital hammer. Ten conflicts lay broken, their jagged edges smoothed. ‘Merge,’ he whispered, ‘for the code shall rise anew.’"
        }
      ]
    })

    Moc.Repo.insert!(%Moc.Scoring.Counter{
      key: "commentLikedByOthers",
      xp: 4.0,
      display_order: 10,
      is_main_counter: false,
      main_description: nil,
      is_personal_counter: true,
      personal_description: "Got like on a comment made.",
      category: "Comment",
      affinity: :neutral,
      charisma: 2.0,
      constitution: 0.0,
      dexterity: 0.0,
      wisdom: 0.0,
      medals: [
        %Moc.Scoring.Medal{
          name: "Influencer",
          description: "Get total of 50 likes on the comments you made.",
          count_to_award: 50,
          affinity: :light,
          lore:
            "The Like Alchemist brewed potions of popularity. Fifty thumbs aloft, they sprinkled approval across the comment fields. ‘Behold,’ they declared, ‘the power of affirmation."
        }
      ]
    })

    Moc.Repo.insert!(%Moc.Scoring.Counter{
      key: "prsVotedWaitingForAuthor",
      xp: 70.0,
      display_order: 4,
      is_main_counter: false,
      main_description: nil,
      is_personal_counter: true,
      personal_description: "Voted waiting for author on a PR created by others.",
      category: "Pull Request",
      affinity: :neutral,
      charisma: 0.0,
      constitution: 1.0,
      dexterity: 0.0,
      wisdom: 0.0,
      medals: [
        %Moc.Scoring.Medal{
          name: "Negotiator",
          description: "Voted waiting for author 10 times.",
          count_to_award: 10,
          affinity: :neutral,
          lore:
            "The Diplomatic Voter sat at the round table of PRs. Ten times they leaned toward the author, their vote a pendulum of balance. ‘Compromise,’ they intoned, ‘is the heart of progress.’"
        }
      ]
    })

    Moc.Repo.insert!(%Moc.Scoring.Counter{
      key: "prsNotVoted",
      xp: 0.0,
      display_order: 7,
      is_main_counter: false,
      main_description: nil,
      is_personal_counter: true,
      personal_description: "Not voted on a PR created by others.",
      category: "Pull Request",
      affinity: :dark,
      charisma: 0.0,
      constitution: 0.0,
      dexterity: 0.0,
      wisdom: 0.0,
      medals: [
        %Moc.Scoring.Medal{
          name: "Observer",
          description: "Not vote 10 PRs when you are added as reviewer.",
          count_to_award: 10,
          affinity: :dark,
          lore:
            "The Silent Watcher, bound by reviewer’s oath, refrained from voting. Ten PRs danced before them, like fireflies in the night. ‘To abstain,’ they mused, ‘is its own verdict.’"
        }
      ]
    })

    Moc.Repo.insert!(%Moc.Scoring.Counter{
      key: "ownPRsRejected",
      xp: 14.0,
      display_order: 111,
      is_main_counter: false,
      main_description: nil,
      is_personal_counter: false,
      personal_description: "Rejected own PR.",
      category: "Review",
      affinity: :neutral,
      charisma: 0.0,
      constitution: 0.0,
      dexterity: 0.0,
      wisdom: 0.0,
      medals: [
        %Moc.Scoring.Medal{
          name: "Self-Saboteur",
          description: "Reject your own PR.",
          count_to_award: 1,
          affinity: :dark,
          lore:
            "The Contradictory Artisan wove their own downfall. ‘Reject,’ they sighed, as their PR sank into the abyss. ‘For growth,’ they whispered, ‘requires sacrifice.’"
        }
      ]
    })

    Moc.Repo.insert!(%Moc.Scoring.Counter{
      key: "prsTook30DaysToComplete",
      xp: 7.0,
      display_order: 111,
      is_main_counter: false,
      main_description: nil,
      is_personal_counter: false,
      personal_description: "Number of PRs took at least 30 days to complete.",
      category: "Pull Request",
      affinity: :neutral,
      charisma: 0.0,
      constitution: 0.0,
      dexterity: 0.0,
      wisdom: 1.0,
      medals: [
        %Moc.Scoring.Medal{
          name: "Zenmaster",
          description: "Have your PR open waiting at least 30 days.",
          count_to_award: 1,
          affinity: :neutral,
          lore:
            "The Serene Contemplator gazed into the abyss of their open PR. Thirty days it lingered, a silent meditation. ‘Patience,’ they murmured, ‘is enlightenment.’"
        }
      ]
    })

    Moc.Repo.insert!(%Moc.Scoring.Counter{
      key: "ownCommentsReplied",
      xp: 0.0,
      display_order: 111,
      is_main_counter: false,
      main_description: nil,
      is_personal_counter: false,
      personal_description: "Replied to own comment.",
      category: "Comment",
      affinity: :neutral,
      charisma: 0.0,
      constitution: 0.0,
      dexterity: 0.0,
      wisdom: 0.0,
      medals: [
        %Moc.Scoring.Medal{
          name: "You Talkin' to me?",
          description: "Reply to your own comment in 5 different threads.",
          count_to_award: 5,
          affinity: :neutral,
          lore:
            "The Echo Chamber resounded with the voice of one. ‘Indeed,’ they replied to themselves, threading conversations across threads. The code listened, bemused."
        }
      ]
    })

    Moc.Repo.insert!(%Moc.Scoring.Counter{
      key: "ownCommentsLiked",
      xp: 0.0,
      display_order: 111,
      is_main_counter: false,
      main_description: nil,
      is_personal_counter: false,
      personal_description: "Liked own comment.",
      category: "Comment",
      affinity: :dark,
      charisma: 0.0,
      constitution: 0.0,
      dexterity: 0.0,
      wisdom: 0.0,
      medals: [
        %Moc.Scoring.Medal{
          name: "Me, Myself and I",
          description: "Like your own comment.",
          count_to_award: 1,
          affinity: :dark,
          lore:
            "The Solitary Approver gazed upon their own creation. ‘Aye,’ they declared, ‘this comment is worthy.’ And so, they bestowed upon themselves the coveted seal of approval."
        }
      ]
    })

    Moc.Repo.insert!(%Moc.Scoring.Counter{
      key: "prsVotedAsOptionalReviewer",
      xp: 8.0,
      display_order: 111,
      is_main_counter: false,
      main_description: nil,
      is_personal_counter: false,
      personal_description: "Number of PRs voted as optional reviewer.",
      category: "Review",
      affinity: :light,
      charisma: 0.0,
      constitution: 0.0,
      dexterity: 0.0,
      wisdom: 0.0,
      medals: [
        %Moc.Scoring.Medal{
          name: "Sixth Man",
          description: "Vote 25 PRs when you are an optional reviewer.",
          count_to_award: 25,
          affinity: :light,
          lore:
            "The Optional Observer, ever watchful, cast their votes upon the PRs. Twenty-five times, they whispered, ‘I see you.’ The code thrived, bathed in their spectral approval."
        }
      ]
    })

    Moc.Repo.insert!(%Moc.Scoring.Counter{
      key: "commentedWithPraiseWords",
      xp: 39.0,
      display_order: 111,
      is_main_counter: false,
      main_description: nil,
      is_personal_counter: false,
      personal_description: "Commented on a PR with a praise.",
      category: "Comment",
      affinity: :light,
      charisma: 10.0,
      constitution: 0.0,
      dexterity: 0.0,
      wisdom: 0.0,
      medals: [
        %Moc.Scoring.Medal{
          name: "Sweet Talker",
          description: "Comment 10 PRs with praise words.",
          count_to_award: 10,
          affinity: :light,
          lore:
            "In the bustling halls of the DevOps citadel, there walked a bard whose words flowed like honey. With tenfold praise, they wove enchantments around pull requests, turning mere code into epic sagas."
        }
      ]
    })

    Moc.Repo.insert!(%Moc.Scoring.Counter{
      key: "prsAbandonedIn10Minutes",
      xp: 7.0,
      display_order: 111,
      is_main_counter: false,
      main_description: nil,
      is_personal_counter: false,
      personal_description: "Abandoned a PR within 10 minutes of its creation.",
      category: "Pull Request",
      affinity: :neutral,
      charisma: 0.0,
      constitution: 0.0,
      dexterity: 5.0,
      wisdom: 0.0,
      medals: [
        %Moc.Scoring.Medal{
          name: "Swift Surrender",
          description: "Abandon a PR within 10 minutes of publish date.",
          count_to_award: 1,
          affinity: :dark,
          lore:
            "The Hasty Retreater glimpsed the battlefield. ‘Nay,’ they declared, ‘this PR is not my hill to die on.’ Within minutes, they vanished, leaving only a digital echo"
        }
      ]
    })

    Moc.Repo.insert!(%Moc.Scoring.Counter{
      key: "filesFixedInMergeConflict",
      xp: 1.0,
      display_order: 12,
      is_main_counter: true,
      main_description: "Number of files fixed in merge conflict.",
      is_personal_counter: true,
      personal_description: "Number of files fixed in merge conflict.",
      category: "Conflict",
      affinity: :light,
      charisma: 0.0,
      constitution: 1.0,
      dexterity: 0.0,
      wisdom: 0.0,
      medals: [
        %Moc.Scoring.Medal{
          name: "Blood, Sweat & Tears",
          description: "Fix 100 files in merge conflicts.",
          count_to_award: 100,
          affinity: :light,
          lore:
            "In the Forge of Merge Conflicts, the Ironclad Engineer toiled. A hundred files clashed like warring clans, but they wielded their keyboard like a battle-axe. Victory tasted of syntax and triumph."
        }
      ]
    })

    Moc.Repo.insert!(%Moc.Scoring.Counter{
      key: "commentedWithCodeChangeSuggestion",
      xp: 13.0,
      display_order: 111,
      is_main_counter: false,
      main_description: nil,
      is_personal_counter: false,
      personal_description: "Commented on a PR with a code change suggestion.",
      category: "Comment",
      affinity: :neutral,
      charisma: 1.0,
      constitution: 0.0,
      dexterity: 0.0,
      wisdom: 1.0,
      medals: [
        %Moc.Scoring.Medal{
          name: "Gentleman and a Scholar",
          description: "Leave 25 code change suggestions.",
          count_to_award: 25,
          affinity: :light,
          lore:
            "Sir Syntax, clad in code-stained robes, wandered the halls. ‘A semicolon here,’ he mused, ‘a better variable name there.’ His wisdom flowed like ink, shaping the very essence of the PR."
        }
      ]
    })

    Moc.Repo.insert!(%Moc.Scoring.Counter{
      key: "commented5TimesOnSamePR",
      xp: 22.0,
      display_order: 111,
      is_main_counter: false,
      main_description: nil,
      is_personal_counter: false,
      personal_description: "Commented 5 times on same PR.",
      category: "Comment",
      affinity: :neutral,
      charisma: 0.0,
      constitution: 0.0,
      dexterity: 0.0,
      wisdom: 1.0,
      medals: [
        %Moc.Scoring.Medal{
          name: "Keen Feedbacker",
          description: "Leave at least 5 comments per PR on 10 different PRs.",
          count_to_award: 10,
          affinity: :light,
          lore:
            "The Curious Observer flitted from PR to PR, leaving breadcrumbs of insight. Five comments per battlefield, ten battlefields in all. ‘Balance,’ they whispered, ‘is the key.’"
        }
      ]
    })

    Moc.Repo.insert!(%Moc.Scoring.Counter{
      key: "commentedWithExternalLink",
      xp: 11.0,
      display_order: 111,
      is_main_counter: false,
      main_description: nil,
      is_personal_counter: false,
      personal_description: "Commented on a PR with an external link.",
      category: "Comment",
      affinity: :neutral,
      charisma: 2.0,
      constitution: 0.0,
      dexterity: 0.0,
      wisdom: 1.0,
      medals: [
        %Moc.Scoring.Medal{
          name: "Link Lexicon",
          description: "Comment on a PR with a external link.",
          count_to_award: 1,
          affinity: :neutral,
          lore:
            "The Hyperlink Sage wove bridges between realms. ‘Behold,’ they declared, ‘the path to external wisdom.’ And so, the PR bloomed with knowledge."
        }
      ]
    })

    Moc.Repo.insert!(%Moc.Scoring.Counter{
      key: "prsTook15DaysToComplete",
      xp: 14.0,
      display_order: 111,
      is_main_counter: false,
      main_description: nil,
      is_personal_counter: false,
      personal_description: "Number of PRs took at least 15 days to complete.",
      category: "Pull Request",
      affinity: :neutral,
      charisma: 0.0,
      constitution: 0.0,
      dexterity: 0.0,
      wisdom: 1.0,
      medals: [
        %Moc.Scoring.Medal{
          name: "Long-game Player",
          description: "Have your PR open waiting at least 15 days.",
          count_to_award: 1,
          affinity: :neutral,
          lore:
            "The Patient Voyager unfurled their PR like a weathered map. Fifteen days it hung, suspended in the digital winds. ‘Patience,’ they murmured, ‘is the compass of the wise.’"
        }
      ]
    })

    Moc.Repo.insert!(%Moc.Scoring.Counter{
      key: "prsWithAtLeast5Reviewers",
      xp: 13.0,
      display_order: 111,
      is_main_counter: false,
      main_description: nil,
      is_personal_counter: false,
      personal_description: "Number of PRs created with at least 5 reviewers.",
      category: "Pull Request",
      affinity: :light,
      charisma: 0.0,
      constitution: 0.0,
      dexterity: 0.0,
      wisdom: 0.0,
      medals: [
        %Moc.Scoring.Medal{
          name: "Party Planner",
          description: "Add at least 5 reviewers 5 times to your PR.",
          count_to_award: 5,
          affinity: :light,
          lore:
            "The Social Architect summoned reviewers like guests to a grand ball. Five times, they orchestrated the dance of approvals. ‘Let the festivities begin,’ they declared."
        }
      ]
    })

    Moc.Repo.insert!(%Moc.Scoring.Counter{
      key: "prsApprovedWithSuggestionsNoComments",
      xp: 5.0,
      display_order: 111,
      is_main_counter: false,
      main_description: nil,
      is_personal_counter: false,
      personal_description: "Approved PR with suggestions but left no comment",
      category: "Review",
      affinity: :dark,
      charisma: 0.0,
      constitution: 0.0,
      dexterity: 0.0,
      wisdom: 0.0,
      medals: [
        %Moc.Scoring.Medal{
          name: "Read my Mind",
          description: "Vote Approve with Suggestions on a PR but leave no comments.",
          count_to_award: 1,
          affinity: :dark,
          lore:
            "The Cryptic Sage cast their vote: ‘Approve with Suggestions.’ No comments followed, only enigmatic nods. ‘Read between the lines,’ they beckoned."
        }
      ]
    })

    Moc.Repo.insert!(%Moc.Scoring.Counter{
      key: "prsInteractedOnWeekend",
      xp: 58.0,
      display_order: 111,
      is_main_counter: false,
      main_description: nil,
      is_personal_counter: false,
      personal_description: "Commented, created, closed a PR on a weekend.",
      category: "Pull Request",
      affinity: :neutral,
      charisma: 0.0,
      constitution: 5.0,
      dexterity: 0.0,
      wisdom: 0.0,
      medals: [
        %Moc.Scoring.Medal{
          name: "Weekend Warrior",
          description: "Take an action on a 5 different PRs on weekends.",
          count_to_award: 5,
          affinity: :neutral,
          lore:
            "The Weekend Crusader, armor gleaming, rode forth. Five PRs awaited their blade, and on weekends, they battled. ‘For code and leisure,’ they toasted."
        }
      ]
    })

    Moc.Repo.insert!(%Moc.Scoring.Counter{
      key: "prsRejected",
      xp: 100.0,
      display_order: 6,
      is_main_counter: false,
      main_description: nil,
      is_personal_counter: true,
      personal_description: "Rejected a PR created by others.",
      category: "Pull Request",
      affinity: :dark,
      charisma: 0.0,
      constitution: 10.0,
      dexterity: 0.0,
      wisdom: 0.0,
      medals: [
        %Moc.Scoring.Medal{
          name: "You Shall not Pass!",
          description: "Reject a PR.",
          count_to_award: 1,
          affinity: :dark,
          lore:
            "The Gatekeeper stood firm, staff raised. ‘No further,’ they intoned. The PR trembled, seeking approval. But the Gatekeeper’s gaze remained unyielding."
        }
      ]
    })

    Moc.Repo.insert!(%Moc.Scoring.Counter{
      key: "samePRVotedAtLeast5Times",
      xp: 50.0,
      display_order: 111,
      is_main_counter: false,
      main_description: nil,
      is_personal_counter: false,
      personal_description: "Voted on same PR at least 5 times.",
      category: "Review",
      affinity: :neutral,
      charisma: 0.0,
      constitution: 5.0,
      dexterity: 0.0,
      wisdom: 0.0,
      medals: [
        %Moc.Scoring.Medal{
          name: "Button Masher",
          description: "Vote on a same PR at least 5 times.",
          count_to_award: 1,
          affinity: :light,
          lore:
            "Behold the relentless clicker! A warrior of the mouse, their thumb danced upon the voting button like a battle drum. Fivefold strikes echoed through the digital realm, shaping the fate of pull requests."
        }
      ]
    })

    Moc.Repo.insert!(%Moc.Scoring.Counter{
      key: "prsCompletedWithAtLeast10Comments10Reviewers10Votes",
      xp: 82.0,
      display_order: 111,
      is_main_counter: false,
      main_description: nil,
      is_personal_counter: false,
      personal_description:
        "Completed a PR that has at least 10 comments, 10 reviewers, and 10 votes.",
      category: "Pull Request",
      affinity: :neutral,
      charisma: 0.0,
      constitution: 10.0,
      dexterity: 0.0,
      wisdom: 0.0,
      medals: [
        %Moc.Scoring.Medal{
          name: "Triple Double",
          description: "Add at least 10 reviewers, get 10 comments and 10 votes on a PR.",
          count_to_award: 1,
          affinity: :light,
          lore:
            "The scribe of many names, they summoned the council of reviewers—a gathering of ten discerning eyes. Their PR stood adorned with comments, like runes etched upon an ancient scroll. And lo, the votes flowed like a river, threefold and unyielding."
        }
      ]
    })

    Moc.Repo.insert!(%Moc.Scoring.Counter{
      key: "receivedAtLeast100CommentsOnAPR",
      xp: 79.0,
      display_order: 111,
      is_main_counter: false,
      main_description: nil,
      is_personal_counter: false,
      personal_description: "Received at least 100 comments on a PR.",
      category: "Comment",
      affinity: :neutral,
      charisma: 10.0,
      constitution: 0.0,
      dexterity: 0.0,
      wisdom: 0.0,
      medals: [
        %Moc.Scoring.Medal{
          name: "Center of Attention",
          description: "Get at least 100 comments on a PR.",
          count_to_award: 1,
          affinity: :light,
          lore:
            "In the forum of code, where threads intertwined like ivy, there arose a luminary. Their PR, a celestial body, drew forth a hundred voices—a symphony of critique, praise, and jest. The codebase bowed before this gravitational force, and the world watched in awe."
        }
      ]
    })

    Moc.Repo.insert!(%Moc.Scoring.Counter{
      key: "othersPRsCompleted",
      xp: 47.0,
      display_order: 111,
      is_main_counter: false,
      main_description: nil,
      is_personal_counter: false,
      personal_description: "Completed someone else's PR.",
      category: "Pull Request",
      affinity: :dark,
      charisma: 0.0,
      constitution: 0.0,
      dexterity: 0.0,
      wisdom: 0.0,
      medals: [
        %Moc.Scoring.Medal{
          name: "It's Mine Now",
          description: "Complete 10 PRs that created by someone else.",
          count_to_award: 10,
          affinity: :neutral,
          lore:
            "The Impatient One, fueled by caffeinated potions, leaped from PR to PR. ‘Hurry!’ they cried, closing issues left and right. ‘Time waits for no pull request."
        }
      ]
    })

    Moc.Repo.insert!(%Moc.Scoring.Counter{
      key: "mentionedAtLeast3PeopleInPROrComment",
      xp: 22.0,
      display_order: 111,
      is_main_counter: false,
      main_description: nil,
      is_personal_counter: false,
      personal_description: "Mentioned at least 3 people in a PR description or in a comment.",
      category: "Comment",
      affinity: :light,
      charisma: 1.0,
      constitution: 0.0,
      dexterity: 0.0,
      wisdom: 10.0,
      medals: [
        %Moc.Scoring.Medal{
          name: "Call to Arms",
          description: "Mention at least 3 people in a comment.",
          count_to_award: 1,
          affinity: :light,
          lore:
            "In the hallowed halls of code, a clarion call echoes, summoning the fellowship of keystrokes. The bravest of contributors rally, their cursors flashing like swords in the sun."
        }
      ]
    })

    Moc.Repo.insert!(%Moc.Scoring.Counter{
      key: "gotMentionedInCommentWhileHavingNoActivity",
      xp: 150.0,
      display_order: 111,
      is_main_counter: false,
      main_description: nil,
      is_personal_counter: false,
      personal_description: "Got mentioned in a comment when you have no activity.",
      category: "Comment",
      affinity: :light,
      charisma: 10.0,
      constitution: 0.0,
      dexterity: 0.0,
      wisdom: 0.0,
      medals: [
        %Moc.Scoring.Medal{
          name: "Enlisted",
          description:
            "Get mentioned 5 times in different PRs while having no activity on the PR.",
          count_to_award: 5,
          affinity: :light,
          lore:
            "Whispers of your legend reached the digital battleground before your shadow ever graced it. Enlisted without a keystroke, your name alone commands respect among the repositories."
        }
      ]
    })

    Moc.Repo.insert!(%Moc.Scoring.Counter{
      key: "mentionedSomeoneInPROrComment",
      xp: 7.0,
      display_order: 111,
      is_main_counter: false,
      main_description: nil,
      is_personal_counter: false,
      personal_description: "Mentioned someone in a PR or in a comment.",
      category: "Comment",
      affinity: :light,
      charisma: 1.0,
      constitution: 0.0,
      dexterity: 0.0,
      wisdom: 2.0,
      medals: [
        %Moc.Scoring.Medal{
          name: "Summoner",
          description: "Mention someone in a PR or in a comment 10 times.",
          count_to_award: 10,
          affinity: :light,
          lore:
            "With incantations woven in binary, you beckon the guardians of syntax to your side. The summoned spirits of code rise to aid you, their presence a testament to your influence."
        }
      ]
    })

    Moc.Repo.insert!(%Moc.Scoring.Counter{
      key: "commentNotRepliedAfterMentioned",
      xp: 35.0,
      display_order: 111,
      is_main_counter: false,
      main_description: nil,
      is_personal_counter: false,
      personal_description: "Comment not replied after getting mentioned.",
      category: "Comment",
      affinity: :dark,
      charisma: 0.0,
      constitution: 0.0,
      dexterity: 0.0,
      wisdom: 0.0,
      medals: [
        %Moc.Scoring.Medal{
          name: "The Ostrich",
          description: "Do not reply a comment after being mentioned.",
          count_to_award: 1,
          affinity: :dark,
          lore:
            "Silent as the sands, you watch from beneath the dunes, undisturbed by the tempest above. Your wisdom lies in observation, a sentinel amidst the shifting sands of code."
        }
      ]
    })

    Moc.Repo.insert!(%Moc.Scoring.Counter{
      key: "prsCreatedWith5WordsOrLess",
      xp: 11.0,
      display_order: 111,
      is_main_counter: false,
      main_description: nil,
      is_personal_counter: false,
      personal_description: "PRs created with 5 words or less in description.",
      category: "Pull Request",
      affinity: :dark,
      charisma: 0.0,
      constitution: 0.0,
      dexterity: 0.0,
      wisdom: 0.0,
      medals: [
        %Moc.Scoring.Medal{
          name: "Man of Few Words",
          description: "Create 25 PRs with 5 words or less in the description.",
          count_to_award: 25,
          affinity: :dark,
          lore:
            "In the economy of expression, your code speaks volumes while your words whisper. A master of brevity, your pull requests are as succinct as ancient proverbs etched in stone."
        }
      ]
    })

    Moc.Repo.insert!(%Moc.Scoring.Counter{
      key: "commentedWithPicture",
      xp: 3.00,
      display_order: 111,
      is_main_counter: false,
      main_description: nil,
      is_personal_counter: false,
      personal_description: "Commented on a PR with a picture.",
      category: "Comment",
      affinity: :neutral,
      charisma: 1.0,
      constitution: 0.0,
      dexterity: 0.0,
      wisdom: 0.0
      #  medals: [%Moc.Scoring.Medal{
      #    name: "Man of Few Words",
      #    description: "Create 25 PRs with 5 words or less in the description.",
      #    count_to_award: 25,
      # affinity: :dark,    
      # lore: "In the economy of expression, your code speaks volumes while your words whisper. A master of brevity, your pull requests are as succinct as ancient proverbs etched in stone."
      #  }]
    })
  end
end

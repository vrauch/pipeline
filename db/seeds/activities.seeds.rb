activities = [
    Activity.new(id: 1, alias: 'brand_login', evo_pattern: '{{user_name}} logged in',
                 brand_pattern: '{{user_name}} logged in', super_only: true),

    Activity.new(id: 2, alias: 'evo_login', evo_pattern: '{{user_name}} logged in', super_only: true),

    Activity.new(id: 3, alias: 'startup_edited_brief', evo_pattern: 'Modified the answer to {{updates}}', updates: true),

    Activity.new(id: 4, alias: 'startup_watchlist_added_by_evo', evo_pattern: 'Added {{startup_name}} to the watchlist'),

    Activity.new(id: 5, alias: 'startup_watchlist_updated_by_evo', evo_pattern: 'Updated {{updates}} for {{startup_name}} ', updates: true),

    Activity.new(id: 6, alias: 'startup_watchlist_added_by_brand', brand_pattern: 'Added {{startup_name}} to the watchlist'),

    Activity.new(id: 7, alias: 'startup_watchlist_updated_by_brand', brand_pattern: 'Updated {{updates}} for {{startup_name}}', updates: true),

    Activity.new(id: 8, alias: 'brand_created', evo_pattern: 'Set up a Pipeline account for {{brand_name}}'),

    Activity.new(id: 9, alias: 'startup_pushed', evo_pattern: 'Pushed {{startup_name}} to {{brand_name}}',
                 brand_pattern: 'Shared the profile for {{startup_name}}'),

    Activity.new(id: 10, alias: 'tag_added_by_evo', evo_pattern: 'Added the tag {{tag_name}} to {{startup_name}}'),

    Activity.new(id: 11, alias: 'tag_added_by_brand', brand_pattern: 'Added the tag {{tag_name}} to {{startup_name}}'),

    Activity.new(id: 12, alias: 'brand_sent_request', evo_pattern: 'Asked about {{request_text}}',
                 brand_pattern: '{{user_name}} sent request of {{request_text}}'),

    Activity.new(id: 13, alias: 'note_added_by_evo', evo_pattern: 'Added a comment "{{note}}" to {{startup_name}}\'s profile'),

    Activity.new(id: 14, alias: 'note_added_by_brand', brand_pattern: 'Added a comment "{{note}}" to {{startup_name}}\'s profile'),

    Activity.new(id: 15, alias: 'task_completed_by_evo_self', evo_pattern: '{{startup_name}}: Completed a task of {{content}}. Assigned by {{author_name}}'),

    Activity.new(id: 16, alias: 'task_completed_by_evo_other', evo_pattern: '{{startup_name}} task completed: {{content}} assigned to {{user_name}}'),

    Activity.new(id: 17, alias: 'evo_answered_on_request', evo_pattern: 'Answered {{author_name}}\'s of {{brand_name}} question of {{request_text}} with {{answer_text}}',
                 brand_pattern: 'Answered request of {{request_text}} with {{answer_text}}'),

    Activity.new(id: 18, alias: 'brand_updated_profile', evo_pattern: 'Updated {{updates}} for {{brand_name}}  profile', updates: true),

    Activity.new(id: 19, alias: 'startup_created_evo_account', evo_pattern: 'Created an account'),

    Activity.new(id: 20, alias: 'startup_created_brand_account', evo_pattern: 'Created an account via {{brand_name}}\'s Pipeline',
                 brand_pattern: 'Created an account'),

    Activity.new(id: 21, alias: 'startup_filled_in_evo_profile', evo_pattern: 'Submitted a profile for {{startup_name}}'),

    Activity.new(id: 22, alias: 'startup_filled_in_brand_profile', evo_pattern: 'Submitted a profile via {{brand_name}}\'s Pipeline',
                                                                   brand_pattern: 'Submitted a profile for {{startup_name}}'),

    Activity.new(id: 23, alias: 'startup_edited_profile', evo_pattern: 'Edited {{updates}}',
                                                          brand_pattern: 'Edited {{updates}}', updates: true),

    Activity.new(id: 24, alias: 'evo_sent_question_to_startup', evo_pattern: 'Sent a question {{question_text}} to {{startup_name}}',
                 startup_pattern: '{{question_text}}'),

    Activity.new(id: 25, alias: 'startup_answered_to_evo', evo_pattern: 'Answered {{answer_text}} to the {{question_text}}'),

    Activity.new(id: 26, alias: 'startup_updated_by_evo', evo_pattern: 'Updated {{updates}} of {{startup_name}} profile', updates: true),

    Activity.new(id: 27, alias: 'startup_updated_by_brand', evo_pattern: 'Updated {{updates}} of {{startup_name}} profile', updates: true),

    Activity.new(id: 28, alias: 'evo_user_created_profile', evo_pattern: 'Created a profile', updates: true),

    Activity.new(id: 29, alias: 'brand_user_created_profile', evo_pattern: 'Created a profile',
                 brand_pattern: 'Created a profile', super_only: true),

    Activity.new(id: 33, alias: 'saved_search_created_by_evo', evo_pattern: 'Created the search query {{search_name}}'),

    Activity.new(id: 34, alias: 'saved_search_created_by_brand', brand_pattern: 'Created the search query {{search_name}}'),

    Activity.new(id: 35, alias: 'saved_search_edited_by_evo', evo_pattern: 'Modified the search query of {{search_name}}'),

    Activity.new(id: 36, alias: 'saved_search_edited_by_brand', brand_pattern: 'Modified the search query of {{search_name}}'),

    Activity.new(id: 37, alias: 'list_created_by_evo', evo_pattern: 'Created the list {{list_name}}'),

    Activity.new(id: 38, alias: 'list_created_by_brand', brand_pattern: 'Created the list {{list_name}}'),

    Activity.new(id: 39, alias: 'list_edited_by_evo', evo_pattern: 'Edited the list {{list_name}}'),

    Activity.new(id: 40, alias: 'list_edited_by_brand', brand_pattern: 'Edited the list {{list_name}}'),

    Activity.new(id: 41, alias: 'm_mv_post_was_sent', evo_pattern: 'Posted {{post_name}} , shared with {{users}}',
                 brand_pattern: 'Published the M+MV Post {{post_name}}',
                 startup_pattern: 'Published the M+MV Post: {{post_name}} with {{content}}'),

    Activity.new(id: 42, alias: 'task_added_by_evo', evo_pattern: 'Assigned {{assignee_name}} a task of "{{content}}" to complete by {{due_date}}'),

    Activity.new(id: 43, alias: 'startup_completed_brief', evo_pattern: 'Submitted a profile via {{brand_name}}\'s Pipeline',
                 brand_pattern: 'Submitted a profile'),

    Activity.new(id: 44, alias: 'task_added_by_brand', brand_pattern: 'Assigned {{assignee_name}} a note of {{content}} to complete by {{due_date}}'),

    Activity.new(id: 45, alias: 'note_edited_by_evo', evo_pattern: '{{user_name}} edited a {{note_type}} {{updates}} at {{startup_name}} startup profile'),

    Activity.new(id: 46, alias: 'note_edited_by_brand', brand_pattern: '{{user_name}} edited a {{note_type}} {{updates}} at {{startup_name}} startup profile'),

    Activity.new(id: 47, alias: 'note_deleted_by_evo', evo_pattern: '{{user_name}} deleted a {{note_type}} "{{note_name}}" at {{startup_name}} startup profile'),

    Activity.new(id: 48, alias: 'note_deleted_by_brand', brand_pattern: '{{user_name}} deleted a {{note_type}} "{{note_name}}" at {{startup_name}} startup profile'),

    Activity.new(id: 49, alias: 'evo_canceled_push', evo_pattern: '{{user_name}} canceled push of startup "{{startup_name}}" to “{{brand_name}}” Database'),

    Activity.new(id: 50, alias: 'evo_commented_note', evo_pattern: '{{user_name}} added a comment “{{comment_text}}” for a {{note_type}} “{{note_text}}” at {{startup_name}}’s profile'),

    Activity.new(id: 51, alias: 'brand_commented_note', brand_pattern: '{{user_name}} added a comment “{{comment_text}}” for a {{note_type}} “{{note_text}}” at {{startup_name}}’s profile'),

    Activity.new(id: 52, alias: 'brand_requested_scorecard',
      evo_pattern: '{{brand_name}} would like a scorecard for {{startup_name}}',
      brand_pattern: 'Sent request of "We would like a scorecard for {{startup_name}}"'
    ),

    Activity.new(id: 53, alias: 'scorecard_sent',
      evo_pattern: 'Sent {{startup_name}} scorecard to {{brand_name}}',
      brand_pattern: 'Sent scorecard for {{startup_name}}'
    ),
    Activity.new(id: 54, alias: 'evo_edited_comment_note', evo_pattern: '{{user_name}} edited a comment “{{comment_text}}” for a {{note_type}} “{{note_text}}” at {{startup_name}}’s profile'),

    Activity.new(id: 55, alias: 'brand_edited_comment_note', brand_pattern: '{{user_name}} edited a comment “{{comment_text}}” for a {{note_type}} “{{note_text}}” at {{startup_name}}’s profile'),

    Activity.new(id: 56, alias: 'evo_deleted_comment_note', evo_pattern: '{{user_name}} deleted a comment “{{comment_text}}” for a {{note_type}} “{{note_text}}” at {{startup_name}}’s profile'),

    Activity.new(id: 57, alias: 'brand_deleted_comment_note', brand_pattern: '{{user_name}} deleted a comment “{{comment_text}}” for a {{note_type}} “{{note_text}}” at {{startup_name}}’s profile'),

]

Activity.import activities, on_duplicate_key_update: [:alias, :evo_pattern, :brand_pattern, :startup_pattern, :updates, :super_only]

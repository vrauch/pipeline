q = Question.find_or_initialize_by(id: 1)
  q.title = 'Problem'
  q.body = 'What market inefficiency does this product attempt to solve?'
  q.question_type = :any
  q.score_type = :product
  q.question_for = :scorecards
  q.is_default = true
  q.variants.destroy_all
  q.variants.build(
    id: 1,
    score: 0,
    title: "Problem is not necessarily a great one - this is more of a nice to have and/or a way to add on to something that \"isn't broke\""
  )
  q.variants.build(
    id: 2,
    score: 1,
    title: 'The problem is obvious, although "paid threshold" is bearable'
  )
  q.variants.build(
    id: 3,
    score: 2,
    title: 'The problem is significant - common and critical'
  )
  puts('Create question -> ', q.id) if q.save

q = Question.find_or_initialize_by(id: 2)
  q.title = 'Competitive Advantage'
  q.body = 'How unique is the startup, relative to the market/current competitive landscape?'
  q.question_type = :any
  q.score_type = :product
  q.question_for = :scorecards
  q.is_default = true
  q.variants.destroy_all
  q.variants.build(
    id: 4,
    score: 0,
    title: 'Not unique - many similar startups in market'
  )
  q.variants.build(
    id: 5,
    score: 1,
    title: 'The idea is not unique, but the execution is unique/differentiating'
  )
  q.variants.build(
    id: 6,
    score: 2,
    title: 'Completely unique - a truly disruptive startup (e.g. patent, first to market)'
  )
  puts('Create question -> ', q.id) if q.save

q = Question.find_or_initialize_by(id: 3)
  q.title = 'Team'
  q.body = 'How strong is the founding team?'
  q.question_type = :any
  q.score_type = :product
  q.question_for = :scorecards
  q.is_default = true
  q.variants.destroy_all
  q.variants.build(
    id: 7,
    score: 0,
    title: 'TBD - nothing special stands out'
  )
  q.variants.build(
    id: 8,
    score: 1,
    title: 'Shows early signs of successful founder DNA'
  )
  q.variants.build(
    id: 9,
    score: 2,
    title: 'Very strong - industry veterans who have done this before and will do it again'
  )
  puts('Create question -> ', q.id) if q.save

q = Question.find_or_initialize_by(id: 4)
  q.title = 'Features and Functionality'
  q.body = 'How compelling is the user experience?'
  q.question_type = :any
  q.score_type = :product
  q.question_for = :scorecards
  q.is_default = true
  q.variants.destroy_all
  q.variants.build(
    id: 10,
    score: 0,
    title: "Poor user experience - doesn't work and doesn't look good"
  )
  q.variants.build(
    id: 11,
    score: 1,
    title: 'Solid user experience, but needs design, usability, and feature improvements'
  )
  q.variants.build(
    id: 12,
    score: 2,
    title: 'Excellent user experience - completely seamless usability, beautiful design, useful features'
  )
  puts('Create question -> ', q.id) if q.save

q = Question.find_or_initialize_by(id: 5)
  q.title = 'Market Potential'
  q.body = 'How strong is the startup roadmap, and how well positioned is it to execute on its vision and growth plans?'
  q.question_type = :any
  q.score_type = :product
  q.question_for = :scorecards
  q.is_default = true
  q.variants.destroy_all
  q.variants.build(
    id: 13,
    score: 0,
    title: 'Typical startup scenario with more unanswered questions than answers, potential to pivot'
  )
  q.variants.build(
    id: 14,
    score: 1,
    title: "Not all the pieces are in place; they've checked the main boxes but have one or two incomplete ones (e.g. small raise required, legal hurdle)"
  )
  q.variants.build(
    id: 15,
    score: 2,
    title: 'Rockstar product and a strategy in place to kill it in the market'
  )
  puts('Create question -> ', q.id) if q.save


# collaboration ===============================================

q = Question.find_or_initialize_by(id: 6)
  q.title = 'Bandwidth'
  q.body = 'Does the startup have the appropriate resources and bandwidth to facilitate a successful brand partnership?'
  q.question_type = :any
  q.score_type = :collaboration
  q.question_for = :scorecards
  q.is_default = true
  q.variants.destroy_all
  q.variants.build(
    id: 16,
    score: 0,
    title: 'No resources or bandwidth - would be chaotic'
  )
  q.variants.build(
    id: 17,
    score: 1,
    title: 'Some resourcing - will be an effort but doable'
  )
  q.variants.build(
    id: 18,
    score: 2,
    title: 'Completely resourced with sufficient bandwidth to take on this partnership'
  )
  puts('Create question -> ', q.id) if q.save

q = Question.find_or_initialize_by(id: 7)
  q.title = 'Attitude'
  q.body = 'How enthusiastic and interested is the startup in a potential brand partnership?'
  q.question_type = :any
  q.score_type = :collaboration
  q.question_for = :scorecards
  q.is_default = true
  q.variants.destroy_all
  q.variants.build(
    id: 19,
    score: 0,
    title: "Low - not enthusiastic at all, don't seem very interested"
  )
  q.variants.build(
    id: 20,
    score: 1,
    title: 'Medium - some level of interest'
  )
  q.variants.build(
    id: 21,
    score: 2,
    title: 'High - very enthusiastic and interested; proactive about collaboration ideas'
  )
  puts('Create question -> ', q.id) if q.save

q = Question.find_or_initialize_by(id: 8)
  q.title = 'Barriers to Entry'
  q.body = 'How easy is it for the brand to take full advantage of this startup collaboration? (e.g. internal resources required, integration into existing systems/processes, set-up time, uses existing brand assets)'
  q.question_type = :any
  q.score_type = :collaboration
  q.question_for = :scorecards
  q.is_default = true
  q.variants.destroy_all
  q.variants.build(
    id: 22,
    score: 0,
    title: 'Difficult'
  )
  q.variants.build(
    id: 23,
    score: 1,
    title: 'Moderate'
  )
  q.variants.build(
    id: 24,
    score: 2,
    title: 'Easy'
  )
  puts('Create question -> ', q.id) if q.save

q = Question.find_or_initialize_by(id: 9)
  q.title = 'Customization'
  q.body = 'How willing is the startup to customize for brand needs?'
  q.question_type = :any
  q.score_type = :collaboration
  q.question_for = :scorecards
  q.is_default = true
  q.variants.destroy_all
  q.variants.build(
    id: 25,
    score: 0,
    title: 'Not at all'
  )
  q.variants.build(
    id: 26,
    score: 1,
    title: 'Somewhat flexible'
  )
  q.variants.build(
    id: 27,
    score: 2,
    title: 'Totally flexible'
  )
  puts('Create question -> ', q.id) if q.save

q = Question.find_or_initialize_by(id: 10)
  q.title = 'Brand Reliance'
  q.body = "How central/integral are big brands to the startup's business and business model?"
  q.question_type = :b2c
  q.score_type = :collaboration
  q.question_for = :scorecards
  q.is_default = true
  q.variants.destroy_all
  q.variants.build(
    id: 28,
    score: 0,
    title: 'Low - big brands are not part of the monetization strategy; startup generates revenue alone'
  )
  q.variants.build(
    id: 29,
    score: 1,
    title: 'Medium - big brands are part of the monetization strategy but not essential'
  )
  q.variants.build(
    id: 30,
    score: 2,
    title: 'High - big brands are critical for revenue and overall success of startup'
  )
  puts('Create question -> ', q.id) if q.save

q = Question.find_or_initialize_by(id: 11)
  q.title = 'Pricing Model'
  q.body = 'Does the startup have a scalable pricing model for continued use?'
  q.question_type = :b2b
  q.score_type = :collaboration
  q.question_for = :scorecards
  q.is_default = true
  q.variants.destroy_all
  q.variants.build(
    id: 31,
    score: 0,
    title: "No - haven't figured out pricing model"
  )
  q.variants.build(
    id: 32,
    score: 1,
    title: 'Maybe - they have a baseline model, but will need to adjust to be able to scale with brand clients'
  )
  q.variants.build(
    id: 33,
    score: 2,
    title: 'Yes - pricing totally makes sense and is in line with market value'
  )
  puts('Create question -> ', q.id) if q.save


# business_alignment ====================================================

q = Question.find_or_initialize_by(id: 12)
  q.title = 'Equity'
  q.body = 'How well does the startup equity align with your brand equity?'
  q.question_type = :b2c
  q.score_type = :business
  q.question_for = :scorecards
  q.is_default = true
  q.variants.destroy_all
  q.variants.build(
    id: 34,
    score: 0,
    title: 'Not aligned at all'
  )
  q.variants.build(
    id: 35,
    score: 1,
    title: 'The partnership makes sense - some alignment'
  )
  q.variants.build(
    id: 36,
    score: 2,
    title: 'Completely aligned - this is the perfect solution for your brand'
  )
  puts('Create question -> ', q.id) if q.save

q = Question.find_or_initialize_by(id: 13)
  q.title = 'Target'
  q.body = "Do the current users of the startup align with your brand's target consumer?"
  q.question_type = :b2c
  q.score_type = :business
  q.question_for = :scorecards
  q.is_default = true
  q.variants.destroy_all
  q.variants.build(
    id: 37,
    score: 0,
    title: 'No'
  )
  q.variants.build(
    id: 38,
    score: 1,
    title: 'Somewhat'
  )
  q.variants.build(
    id: 39,
    score: 2,
    title: 'Yes'
  )
  puts('Create question -> ', q.id) if q.save

q = Question.find_or_initialize_by(id: 14)
  q.title = 'Brand Value'
  q.body = 'How much value is your brand (vs. other brands) able to bring this startup?'
  q.question_type = :b2c
  q.score_type = :business
  q.question_for = :scorecards
  q.is_default = true
  q.variants.destroy_all
  q.variants.build(
    id: 40,
    score: 0,
    title: 'Not much - any given brand could bring the same value'
  )
  q.variants.build(
    id: 41,
    score: 1,
    title: 'Some - incremental reach (e.g. ad budget, consumer base, research, 3rd party relationships)'
  )
  q.variants.build(
    id: 42,
    score: 2,
    title: 'Tons - unprecedented access, credibility, game changer for the startup, you are THE brand soulmate for this startup'
  )
  puts('Create question -> ', q.id) if q.save

q = Question.find_or_initialize_by(id: 15)
  q.title = 'Consumer Value'
  q.body = 'What new level of utility would this partnership bring to consumers?'
  q.question_type = :b2c
  q.score_type = :business
  q.question_for = :scorecards
  q.is_default = true
  q.variants.destroy_all
  q.variants.build(
    id: 43,
    score: 0,
    title: 'None - no perceived incremental utility'
  )
  q.variants.build(
    id: 44,
    score: 1,
    title: 'Medium - provides some incremental utility'
  )
  q.variants.build(
    id: 45,
    score: 2,
    title: 'High - 1+1=3, partnership delivers the brand as a service'
  )
  puts('Create question -> ', q.id) if q.save

q = Question.find_or_initialize_by(id: 16)
  q.title = 'Partnership Aspirations'
  q.body = 'Is this startup interested in the same  goal of the partnership as your brand? (Define a continuum of answers based on your  goal, e.g. investment, acquisition, exclusive partnership, etc.)'
  q.question_type = :b2c
  q.score_type = :business
  q.question_for = :scorecards
  q.is_default = true
  q.variants.destroy_all
  q.variants.build(
    id: 46,
    score: 0,
    title: 'No'
  )
  q.variants.build(
    id: 47,
    score: 1,
    title: 'Potentially'
  )
  q.variants.build(
    id: 48,
    score: 2,
    title: 'Yes'
  )
  puts('Create question -> ', q.id) if q.save

q = Question.find_or_initialize_by(id: 17)
  q.title = 'Coverage'
  q.body = "How likely is this partnership to reach a significant portion of the brand's target market?"
  q.question_type = :b2c
  q.score_type = :business
  q.question_for = :scorecards
  q.is_default = true
  q.variants.destroy_all
  q.variants.build(
    id: 49,
    score: 0,
    title: 'Niche market play'
  )
  q.variants.build(
    id: 50,
    score: 1,
    title: 'Will stabilize with a subset of target but never reach mass'
  )
  q.variants.build(
    id: 51,
    score: 2,
    title: 'Potential to reach total saturation within target'
  )
  puts('Create question -> ', q.id) if q.save

q = Question.find_or_initialize_by(id: 18)
  q.title = 'Social Sharing & Virality'
  q.body = 'How endemic are social components in the brand-startup ecosystem? (e.g. open API, social sharing, connectivity)'
  q.question_type = :b2c
  q.score_type = :business
  q.question_for = :scorecards
  q.is_default = true
  q.variants.destroy_all
  q.variants.build(
    id: 52,
    score: 0,
    title: 'Singular user experience'
  )
  q.variants.build(
    id: 53,
    score: 1,
    title: 'Optional social triggers'
  )
  q.variants.build(
    id: 54,
    score: 2,
    title: 'Inherent - necessary social elements'
  )
  puts('Create question -> ', q.id) if q.save

q = Question.find_or_initialize_by(id: 19)
  q.title = 'Experience with Brands'
  q.body = "How many brands has the startup worked with? (Customize options based on what you're looking for, e.g. competitive first, total first)"
  q.question_type = :b2c
  q.score_type = :business
  q.question_for = :scorecards
  q.is_default = true
  q.variants.destroy_all
  q.variants.build(
    id: 55,
    score: 0,
    title: 'Worked with many brands'
  )
  q.variants.build(
    id: 56,
    score: 1,
    title: 'Piloted with 1 or 2 Fortune 500 brands'
  )
  q.variants.build(
    id: 57,
    score: 2,
    title: 'None - first mover advantage'
  )
  puts('Create question -> ', q.id) if q.save

q = Question.find_or_initialize_by(id: 20)
  q.title = 'Barriers to Exit'
  q.body = 'If this reaches its potential, how difficult will it be for users to leave and competitors to steal share?'
  q.question_type = :b2c
  q.score_type = :business
  q.question_for = :scorecards
  q.is_default = true
  q.variants.destroy_all
  q.variants.build(
    id: 58,
    score: 0,
    title: 'Not difficult - users will leave, idea can be knocked off, no data is engrained'
  )
  q.variants.build(
    id: 59,
    score: 1,
    title: 'A bit difficult - users have an attachment but it is fleeting and data can be transferred'
  )
  q.variants.build(
    id: 60,
    score: 2,
    title: 'Extremely difficult - users will be inextricably linked, all their data is there'
  )
  puts('Create question -> ', q.id) if q.save

q = Question.find_or_initialize_by(id: 21)
  q.title = 'Revenue Potential'
  q.body = 'What is the potential future revenue that this partnership could bring to your brand?'
  q.question_type = :b2c
  q.score_type = :business
  q.question_for = :scorecards
  q.is_default = true
  q.variants.destroy_all
  q.variants.build(
    id: 61,
    score: 0,
    title: "None - there's no opportunity for revenue generation from this startup"
  )
  q.variants.build(
    id: 62,
    score: 1,
    title: "Moderate - pilot wouldn't generate revenue, but future potential exists (e.g. realistic acquisition, brand makes money from ad revenue or new product/service)"
  )
  q.variants.build(
    id: 63,
    score: 2,
    title: 'High - this partnership by design will immediately generate a new revenue stream (e.g. via sale/subscription of the startup product/service)'
  )
  puts('Create question -> ', q.id) if q.save

q = Question.find_or_initialize_by(id: 22)
  q.title = 'Product Development Stage'
  q.body = "What stage of development is the startup in? (Customize options based on what you're looking for)"
  q.question_type = :b2c
  q.score_type = :business
  q.question_for = :scorecards
  q.is_default = true
  q.variants.destroy_all
  q.variants.build(
    id: 64,
    score: 0,
    title: 'Prototype/business plan'
  )
  q.variants.build(
    id: 65,
    score: 1,
    title: 'Live'
  )
  q.variants.build(
    id: 66,
    score: 2,
    title: 'Beta, just launched'
  )
  puts('Create question -> ', q.id) if q.save


# business_alignment B2B =======================================================

q = Question.find_or_initialize_by(id: 23)
  q.title = 'Resource Requirements'
  q.body = 'How easy will it be for your brand to take full advantage of this startup technology?'
  q.question_type = :b2b
  q.score_type = :business
  q.question_for = :scorecards
  q.is_default = true
  q.variants.destroy_all
  q.variants.build(
    id: 67,
    score: 0,
    title: 'Difficult - will need a large amount of internal brand resources to get value from the technology'
  )
  q.variants.build(
    id: 68,
    score: 1,
    title: 'Moderate - some internal brand resources required, but fits within existing resource structure'
  )
  q.variants.build(
    id: 69,
    score: 2,
    title: 'Easy - the startup does a majority of the work and internal resources are only required for oversight'
  )
  puts('Create question -> ', q.id) if q.save

q = Question.find_or_initialize_by(id: 24)
  q.title = 'Capabilities and Features'
  q.body = "Does the startup have the specific features or functionality that is necessary to solve your brand's challenge?"
  q.question_type = :b2b
  q.score_type = :business
  q.question_for = :scorecards
  q.is_default = true
  q.variants.destroy_all
  q.variants.build(
    id: 70,
    score: 0,
    title: 'No and not on their roadmap'
  )
  q.variants.build(
    id: 71,
    score: 1,
    title: 'No but on their roadmap'
  )
  q.variants.build(
    id: 72,
    score: 2,
    title: 'Yes'
  )
  puts('Create question -> ', q.id) if q.save

q = Question.find_or_initialize_by(id: 25)
  q.title = 'Impact on Business'
  q.body = 'How transformative is this technology solution for your business? (e.g. Does it solve an important challenge? Does it help you market better, faster, cheaper?)'
  q.question_type = :b2b
  q.score_type = :business
  q.question_for = :scorecards
  q.is_default = true
  q.variants.destroy_all
  q.variants.build(
    id: 73,
    score: 0,
    title: 'Not very impactful'
  )
  q.variants.build(
    id: 74,
    score: 1,
    title: 'Incremental impact'
  )
  q.variants.build(
    id: 75,
    score: 2,
    title: 'Will completely transform your business/product'
  )
  puts('Create question -> ', q.id) if q.save

q = Question.find_or_initialize_by(id: 26)
  q.title = 'Shared Relevance'
  q.body = 'How relevant is the startup solution to the broader organization?'
  q.question_type = :b2b
  q.score_type = :business
  q.question_for = :scorecards
  q.is_default = true
  q.variants.destroy_all
  q.variants.build(
    id: 76,
    score: 0,
    title: 'Only relevant to this specific use case'
  )
  q.variants.build(
    id: 77,
    score: 1,
    title: 'Applicable to a few other departments, brands, or campaigns'
  )
  q.variants.build(
    id: 78,
    score: 2,
    title: 'Completely relevant for continued use by the overall organization'
  )
  puts('Create question -> ', q.id) if q.save

q = Question.find_or_initialize_by(id: 27)
  q.title = 'Portfolio Benefits'
  q.body = 'If multiple brands use this technology, will it benefit the broader portfolio? (e.g. facilitate cross-selling, up-selling, portfolio management)'
  q.question_type = :b2b
  q.score_type = :business
  q.question_for = :scorecards
  q.is_default = true
  q.variants.destroy_all
  q.variants.build(
    id: 79,
    score: 0,
    title: 'Not at all'
  )
  q.variants.build(
    id: 80,
    score: 1,
    title: 'Somewhat'
  )
  q.variants.build(
    id: 81,
    score: 2,
    title: 'Completely - this is what the technology/platform is designed to do'
  )
  puts('Create question -> ', q.id) if q.save

q = Question.find_or_initialize_by(id: 28)
  q.title = 'Geography'
  q.body = 'How geographically scalable is this technology solution? (Customize based on your scale objectives and business reach)'
  q.question_type = :b2b
  q.score_type = :business
  q.question_for = :scorecards
  q.is_default = true
  q.variants.destroy_all
  q.variants.build(
    id: 82,
    score: 0,
    title: 'Only available in test market and no plans to expand in near future'
  )
  q.variants.build(
    id: 83,
    score: 1,
    title: 'Not able to scale in all goal regions today, but ability to customize to scale in near future'
  )
  q.variants.build(
    id: 84,
    score: 2,
    title: 'Completely scalable today (language, regional tech requirements, infrastructure, etc.)'
  )
  puts('Create question -> ', q.id) if q.save

q = Question.find_or_initialize_by(id: 29)
  q.title = 'Product Development Stage'
  q.body = "What stage of development is the startup in? (Customize options based on what you're looking for)"
  q.question_type = :b2b
  q.score_type = :business
  q.question_for = :scorecards
  q.is_default = true
  q.variants.destroy_all
  q.variants.build(
    id: 85,
    score: 0,
    title: 'Prototype/Business Plan'
  )
  q.variants.build(
    id: 86,
    score: 1,
    title: 'Live'
  )
  q.variants.build(
    id: 87,
    score: 2,
    title: 'Beta, just launched'
  )
  puts('Create question -> ', q.id) if q.save

q = Question.find_or_initialize_by(id: 30)
  q.title = 'Experience with Brands'
  q.body = "How many brands has the startup worked with? (Customize options based on what you're looking for, e.g. competitive first, total first)"
  q.question_type = :b2b
  q.score_type = :business
  q.question_for = :scorecards
  q.is_default = true
  q.variants.destroy_all
  q.variants.build(
    id: 88,
    score: 0,
    title: 'Worked with many brands'
  )
  q.variants.build(
    id: 89,
    score: 1,
    title: 'Piloted with 1 or 2 Fortune 500 brands'
  )
  q.variants.build(
    id: 90,
    score: 2,
    title: 'None, first mover advantage'
  )
  puts('Create question -> ', q.id) if q.save

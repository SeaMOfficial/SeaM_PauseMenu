Config = {}

Config.Brand = 'SeaM'
Config.ServerName = 'SeaM Roleplay'
Config.Tagline = 'The sea can wait a moment.'
Config.BlurBackground = true

-- The Report button runs this command. The default opens SeaM_Admin's report
-- centre. The button only shows while Config.ReportResource is running; set
-- ReportCommand to '' to hide it everywhere.
Config.ReportCommand = 'report'
Config.ReportResource = 'SeaM_Admin'

-- Paste your full HTTPS URLs. Entries with an empty or invalid URL are hidden.
-- Add, remove, or reorder entries here. Icons: discord, store, book, globe, link.
Config.Links = {
    { label = 'The Crew', description = 'Join our Discord', icon = 'discord', url = '' },
    { label = 'The Merchant', description = 'Visit our Tebex store', icon = 'store', url = '' },
    -- { label = 'The Articles', description = 'Read the server rules', icon = 'book', url = 'https://example.com/rules' },
}

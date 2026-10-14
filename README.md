# SeaM_PauseMenu

A standalone FiveM pause menu with a Svelte interface styled to match the SeaM parchment, timber, oxblood and gold design. Made by NRG Development.

## Install

1. Copy the `SeaM_PauseMenu` folder into your server's `resources` directory. Keep the folder name exactly `SeaM_PauseMenu`.
2. Add `ensure SeaM_PauseMenu` to `server.cfg`. No QBCore, ESX, ox or database dependency is required.
3. Edit `config.lua` and paste your actual Discord, Tebex, rules or website URLs in `Config.Links`.
4. Restart the resource or server. ESC, P and controller Start open SeaM_PauseMenu in place of the default pause screen.

The ready-to-run Svelte build is already in `html/`. Node.js is needed only if you change the UI source.

## Configuring links

Only entries with a full `https://` URL are shown. Empty placeholders are hidden so players never click a dead button.

```lua
Config.Links = {
    { label = 'The Crew', description = 'Join our Discord', icon = 'discord', url = 'https://discord.gg/your-invite' },
    { label = 'The Merchant', description = 'Visit our Tebex store', icon = 'store', url = 'https://yourstore.tebex.io/' },
    { label = 'The Articles', description = 'Read the rules', icon = 'book', url = 'https://yourdomain.com/rules' },
}
```

Available icons: `discord`, `store`, `book`, `globe`, `link`. Links open in the player's normal browser from FiveM's NUI.

## Other settings

- `Config.Brand`, `Config.ServerName`, `Config.Tagline`: menu text.
- `Config.BlurBackground`: controls the in-game blur while this menu is open.
- `Config.ReportCommand` / `Config.ReportResource`: the Report button runs `/report` (SeaM_Admin's report centre) and only appears while SeaM_Admin is running. Set `ReportCommand = ''` to remove the button.

Resume releases NUI focus. Map and Settings hand off to GTA's native frontend at the respective page. Disconnect asks for confirmation. The player count comes from the server and is refreshed while the menu is open. Player name, server ID, ping, session time and in-world clock are read from FiveM.

## Editing the Svelte UI

```bash
cd SeaM_PauseMenu/web
npm ci
npm run check
npm run build
```

`npm run build` writes directly to `../html`. For a local browser layout preview, run `npm run dev` and append `?preview=1` to the URL. Browser preview uses sample data; the actual menu remains hidden until FiveM opens it.

## Notes

This resource cannot be visually tested inside a FiveM game from this package build environment. If another custom pause resource intercepts ESC/P, disable that resource's pause key handler so only one resource owns the pause controls.

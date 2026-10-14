<script>
  import { onMount } from 'svelte';
  import Icon from './Icon.svelte';
  import './style.css';

  const preview = new URLSearchParams(location.search).has('preview');
  let visible = preview;
  let confirming = false;
  let busy = false;
  let brand = 'SeaM';
  let serverName = 'SeaM Roleplay';
  let tagline = 'The sea can wait a moment.';
  let hasReport = true;
  let links = preview ? [
    { label: 'The Crew', description: 'Join our Discord', icon: 'discord', url: 'https://discord.com/' },
    { label: 'The Merchant', description: 'Visit our Tebex store', icon: 'store', url: 'https://tebex.io/' },
    { label: 'The Articles', description: 'Read the rules', icon: 'book', url: 'https://example.com/' }
  ] : [];
  let stats = { playerName: 'Captain', serverId: 0, population: 0, slots: 0, ping: 0, hours: 0, minutes: 0, sessionMinutes: 0 };

  $: gameTime = `${String(stats.hours ?? 0).padStart(2, '0')}:${String(stats.minutes ?? 0).padStart(2, '0')}`;
  $: sessionTime = stats.sessionMinutes >= 60
    ? `${Math.floor(stats.sessionMinutes / 60)}h ${stats.sessionMinutes % 60}m`
    : `${stats.sessionMinutes || 0}m`;
  $: initials = String(stats.playerName || 'S').trim().charAt(0).toUpperCase();

  onMount(() => {
    const onMessage = (event) => {
      const message = event.data;
      if (!message || typeof message !== 'object') return;
      if (message.type === 'open') {
        const settings = message.config || {};
        brand = settings.brand || 'SeaM';
        serverName = settings.serverName || 'SeaM Roleplay';
        tagline = settings.tagline || 'The sea can wait a moment.';
        links = Array.isArray(settings.links) ? settings.links.filter((item) => validUrl(item.url)) : [];
        hasReport = !!settings.hasReport;
        stats = { ...stats, ...message.data };
        confirming = false;
        busy = false;
        visible = true;
      } else if (message.type === 'stats') {
        stats = { ...stats, ...message.data };
      } else if (message.type === 'close') {
        confirming = false;
        visible = false;
        busy = false;
      }
    };
    const onKey = (event) => {
      if (!visible) return;
      if (event.key === 'Escape') {
        event.preventDefault();
        if (confirming) confirming = false;
        else doAction('close');
      }
    };
    window.addEventListener('message', onMessage);
    window.addEventListener('keydown', onKey);
    return () => {
      window.removeEventListener('message', onMessage);
      window.removeEventListener('keydown', onKey);
    };
  });

  function validUrl(value) {
    try { return new URL(value).protocol === 'https:'; }
    catch { return false; }
  }

  async function doAction(action) {
    if (busy) return;
    if (preview) {
      if (action === 'disconnect') confirming = false;
      else if (action === 'close') visible = false;
      return;
    }
    busy = true;
    try {
      const response = await fetch(`https://${GetParentResourceName()}/action`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json; charset=UTF-8' },
        body: JSON.stringify({ action })
      });
      const result = await response.json();
      if (!result.ok) busy = false;
    } catch (error) {
      console.error('[SeaM_PauseMenu] Action failed:', error);
      busy = false;
    }
  }

  function openLink(url) {
    if (!validUrl(url)) return;
    try {
      if (typeof window.invokeNative === 'function') {
        window.invokeNative('openUrl', url);
        return;
      }
    } catch (error) { console.warn('[SeaM_PauseMenu] Browser handoff failed:', error); }
    window.open(url, '_blank', 'noopener,noreferrer');
  }
</script>

{#if visible}
  <div class="shade" aria-hidden="true"></div>
  <main class="menu-shell" aria-label="SeaM pause menu">
    <aside class="sidebar">
      <div class="brand-block">
        <div class="brand-seal" aria-hidden="true">S</div>
        <div class="brand-text"><strong>{brand}</strong><span>HARBOUR COMMAND</span></div>
      </div>

      <div class="sidebar-content">
        <p class="side-heading">YOUR QUARTERS</p>
        <button class="side-item selected" type="button" aria-current="page">
          <Icon name="compass" size={20}/><span>Overview</span><span class="side-diamond">◆</span>
        </button>
        <button class="side-item" type="button" onclick={() => doAction('map')}>
          <Icon name="map" size={19}/><span>Chart the waters</span><Icon name="chevron" size={15}/>
        </button>
        <button class="side-item" type="button" onclick={() => doAction('settings')}>
          <Icon name="gear" size={19}/><span>GTA settings</span><Icon name="chevron" size={15}/>
        </button>

        {#if links.length}
          <p class="side-heading secondary">BEYOND THE HARBOUR</p>
          {#each links as item, index}
            <button class="side-item" type="button" onclick={() => openLink(item.url)}>
              <Icon name={item.icon} size={19}/><span>{item.label}</span><span class="external-mark">↗</span>
            </button>
          {/each}
        {/if}

        {#if hasReport}
          <p class="side-heading secondary">NEED A HAND?</p>
          <button class="side-item" type="button" onclick={() => doAction('report')}>
            <Icon name="report" size={19}/><span>Make a report</span><Icon name="chevron" size={15}/>
          </button>
        {/if}
      </div>

      <div class="sidebar-bottom">
        <div class="sidebar-person"><div class="avatar-small">{initials}</div><div><strong>{stats.playerName}</strong><span>SAILOR · ID {stats.serverId}</span></div></div>
        <button class="leave-button" type="button" onclick={() => confirming = true}><Icon name="door" size={18}/><span>Leave the voyage</span><span>↗</span></button>
      </div>
    </aside>

    <section class="parchment">
      <div class="paper-grain" aria-hidden="true"></div>
      <header class="topbar">
        <div><span class="eyebrow top-eyebrow">{serverName.toUpperCase()} / THE CAPTAIN'S QUARTERS</span><h1>Safe harbour, sailor.</h1><p>{tagline}</p></div>
        <div class="top-actions"><span class="status"><span class="status-dot"></span> ABOARD</span><button class="close-button" type="button" aria-label="Close pause menu" onclick={() => doAction('close')}><Icon name="close" size={19}/></button></div>
      </header>

      <div class="content-scroll">
        <div class="intro-line"><span class="eyebrow">YOUR VOYAGE AT A GLANCE</span><span class="ornament">◆</span><span class="intro-rule"></span><span class="edition">SEA M · ISSUE 01</span></div>

        <section class="hero" aria-label="Welcome aboard">
          <div class="hero-copy"><span class="hero-kicker">A MOMENT BETWEEN TIDES</span><h2>The horizon<br/>is yours.</h2><p>Catch your breath, check the charts, or call on your crew. Your voyage waits right where you left it.</p><button type="button" class="gold-button hero-button" onclick={() => doAction('close')}><Icon name="anchor" size={18}/><span>RETURN TO THE WATERS</span><Icon name="arrow" size={18}/></button></div>
          <div class="compass-art" aria-hidden="true"><div class="outer-ring"><div class="inner-ring"><span class="north">N</span><span class="east">E</span><span class="south">S</span><span class="west">W</span><div class="needle-a"></div><div class="needle-b"></div><div class="needle-center">✦</div></div></div><span class="art-caption">FOLLOW YOUR OWN BEARING</span></div>
        </section>

        <div class="stats-row" aria-label="Server details">
          <div class="stat"><span class="stat-label">01 / YOUR NAME</span><strong>{stats.playerName}</strong><small>IDENTITY NO. {stats.serverId}</small></div>
          <div class="stat"><span class="stat-label">02 / CREW ABOARD</span><strong>{stats.population}<span class="stat-outof"> / {stats.slots || '—'}</span></strong><small>SAILORS IN THE WATERS</small></div>
          <div class="stat"><span class="stat-label">03 / LOCAL TIDE</span><strong>{gameTime}</strong><small>IN-WORLD TIME</small></div>
          <div class="stat"><span class="stat-label">04 / YOUR VOYAGE</span><strong>{sessionTime}</strong><small>SESSION TIME · {stats.ping} MS</small></div>
        </div>

        <div class="section-title"><div><span class="eyebrow">CHOOSE YOUR COURSE</span><h3>Where to next?</h3></div><span class="section-flourish">✦ &nbsp; ✦ &nbsp; ✦</span></div>
        <div class="action-grid">
          <button type="button" class="action-card chart-card" onclick={() => doAction('map')}><span class="card-number">01 / NAVIGATION</span><span class="card-icon"><Icon name="map" size={29}/></span><strong>Chart the waters</strong><span class="card-desc">Open the map and plot your next course.</span><span class="card-footer">OPEN THE MAP <Icon name="arrow" size={18}/></span></button>
          <button type="button" class="action-card settings-card" onclick={() => doAction('settings')}><span class="card-number">02 / THE VESSEL</span><span class="card-icon"><Icon name="gear" size={29}/></span><strong>Set things right</strong><span class="card-desc">Open GTA's settings and adjust your voyage.</span><span class="card-footer">OPEN SETTINGS <Icon name="arrow" size={18}/></span></button>
        </div>

        {#if links.length}
          <div class="section-title community-title"><div><span class="eyebrow">THE WORLD BEYOND</span><h3>Stay in the company.</h3></div><span class="section-flourish">◆</span></div>
          <div class="links-grid">
            {#each links as item}
              <button class="link-card" type="button" onclick={() => openLink(item.url)}><span class="link-icon"><Icon name={item.icon} size={23}/></span><span class="link-copy"><strong>{item.label}</strong><small>{item.description}</small></span><span class="link-arrow">↗</span></button>
            {/each}
          </div>
        {/if}

        <footer class="content-footer"><span>✦ &nbsp; MAY THE WINDS FAVOUR YOU</span><span>CRAFTED BY NRG DEVELOPMENT</span></footer>
      </div>
    </section>
  </main>

  {#if confirming}
    <div class="confirm-backdrop" role="presentation" onclick={() => confirming = false}></div>
    <div class="confirm-wrap" role="alertdialog" aria-modal="true" aria-labelledby="confirm-title" aria-describedby="confirm-desc">
      <span class="eyebrow">BEFORE YOU SET SAIL</span><h2 id="confirm-title">Leave the voyage?</h2><p id="confirm-desc">You will disconnect from {serverName}. Your journey can resume when you return.</p>
      <div class="confirm-actions"><button type="button" class="outline-button" onclick={() => confirming = false}>STAY ABOARD</button><button type="button" class="red-button" onclick={() => doAction('disconnect')}>DISCONNECT <Icon name="arrow" size={17}/></button></div>
    </div>
  {/if}
{/if}

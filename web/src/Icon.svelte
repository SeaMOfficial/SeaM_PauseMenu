<script>
  export let name = 'compass';
  export let size = 20;
</script>

<svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.55" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
  {#if name === 'compass'}
    <circle cx="12" cy="12" r="9"/><path d="m15.7 8.3-2.3 5.1-5.1 2.3 2.3-5.1z"/><path d="M12 2v2m0 16v2M2 12h2m16 0h2"/>
  {:else if name === 'anchor'}
    <path d="M12 3v17m-4-8H5a7 7 0 0 0 14 0h-3M9 7h6M7 20l-2-2m12 2 2-2"/><circle cx="12" cy="3" r="1.5"/>
  {:else if name === 'map'}
    <path d="m3 5 6-2 6 2 6-2v16l-6 2-6-2-6 2zM9 3v16m6-14v16"/>
  {:else if name === 'gear'}
    <path d="M10 2h4l.5 2.1 1.7.8 1.9-1 2.8 2.8-1 1.9.8 1.7L22 10v4l-2.1.5-.8 1.7 1 1.9-2.8 2.8-1.9-1-1.7.8L14 22h-4l-.5-2.1-1.7-.8-1.9 1-2.8-2.8 1-1.9-.8-1.7L2 14v-4l2.1-.5.8-1.7-1-1.9L6.7 3l1.9 1 1.7-.8z"/><circle cx="12" cy="12" r="3"/>
  {:else if name === 'discord'}
    <path d="M7.5 5.5a16 16 0 0 1 9 0l1 2a13 13 0 0 1 2.5 9.2 16 16 0 0 1-4.2 2l-1-1.5a10 10 0 0 0 1.6-.8 10 10 0 0 1-8.8 0 10 10 0 0 0 1.6.8l-1 1.5a16 16 0 0 1-4.2-2A13 13 0 0 1 6.5 7.5z"/><circle cx="9" cy="12" r=".8" fill="currentColor" stroke="none"/><circle cx="15" cy="12" r=".8" fill="currentColor" stroke="none"/>
  {:else if name === 'store'}
    <path d="M3 9h18l-1.5-5h-15zM4 9v11h16V9M9 20v-7h6v7M3 9c0 2 3 3 4.5 1.5C9 12 11 11 12 9c1 2 3 3 4.5 1.5C18 12 21 11 21 9"/>
  {:else if name === 'book'}
    <path d="M12 5c-2-2-6-2-9-1v15c3-1 7-1 9 1 2-2 6-2 9-1V4c-3-1-7-1-9 1zm0 0v15"/>
  {:else if name === 'globe'}
    <circle cx="12" cy="12" r="9"/><path d="M3 12h18M12 3c5 5 5 13 0 18M12 3c-5 5-5 13 0 18"/>
  {:else if name === 'report'}
    <path d="M5 4h14v13H9l-4 4zM8 9h8m-8 4h5"/>
  {:else if name === 'door'}
    <path d="M4 21h16M6 21V3h12v18M13.5 12h.1"/>
  {:else if name === 'arrow'}
    <path d="M4 12h16m-6-6 6 6-6 6"/>
  {:else if name === 'close'}
    <path d="M5 5 19 19M19 5 5 19"/>
  {:else if name === 'link'}
    <path d="M10 13a5 5 0 0 0 7 .3l3-3a5 5 0 0 0-7-7l-2 2M14 11a5 5 0 0 0-7-.3l-3 3a5 5 0 0 0 7 7l2-2"/>
  {:else if name === 'person'}
    <circle cx="12" cy="8" r="4"/><path d="M4 21a8 8 0 0 1 16 0"/>
  {:else if name === 'clock'}
    <circle cx="12" cy="12" r="9"/><path d="M12 7v5l3 2"/>
  {:else if name === 'chevron'}
    <path d="m9 5 7 7-7 7"/>
  {:else if name === 'spark'}
    <path d="m12 2 1.8 7.2L21 11l-7.2 1.8L12 20l-1.8-7.2L3 11l7.2-1.8z"/>
  {/if}
</svg>

<script lang="ts">
  import { leftClamp, rightClamp, scale, x, y, precision } from "$lib/stores";
  import { Canvas } from "@threlte/core";
  import Scene from "$lib/Scene.svelte";
</script>

<h1>
  Me when I draw the set of all points in the complex plane that do not diverge
  when recursively applied to the function f(z)=z<sup>2</sup>+c (with z starting
  at 0 and c being some point on the complex plane.)
</h1>
<section style="margin-bottom: 2rem;">
  <h2>Controls</h2>
  <fieldset>
    <legend>Screen Clip</legend>
    <label>
      Left Clip
      <div>
        <input
          type="range"
          min="-5"
          max="0"
          step="0.1"
          bind:value={$leftClamp}
        />
        <output>{$leftClamp}</output>
      </div>
    </label>
    <label>
      Right Clip
      <div>
        <input
          type="range"
          min="0"
          max="5"
          step="0.1"
          bind:value={$rightClamp}
        />
        <output>{$rightClamp}</output>
      </div>
    </label>
  </fieldset>
  <fieldset>
    <legend>transform</legend>
    <label>
      X
      <div>
        <input type="range" min="-2" max="2" step="0.01" bind:value={$x} />
        <output>{$x}</output>
      </div>
    </label>
    <label>
      Y
      <div>
        <input type="range" min="-2" max="2" step="0.01" bind:value={$y} />
        <output>{$y}</output>
      </div>
      <label>
        Zoom
        <div>
          <input
            type="range"
            min="0"
            max="100"
            step="0.01"
            bind:value={$scale}
          />
          <output>{$scale}</output>
        </div>
      </label>
    </label>
  </fieldset>
  <fieldset>
    <legend>render options</legend>
    <label>
      Precision
      <div>
        <input
          type="range"
          min="1"
          max="20"
          step="0.1"
          bind:value={$precision}
        />
        <output>{$precision}</output>
      </div>
    </label>
  </fieldset>
</section>
<main id="primary">
  <Canvas>
    <Scene />
  </Canvas>
</main>

<style>
  #primary {
    width: 100%;
    aspect-ratio: 16/10;
    max-height: 90vh;
  }

  fieldset {
    display: inline;
    width: fit-content;
  }

  label {
    width: fit-content;
    display: flex;
    flex-direction: column;
    justify-content: center;
  }

  label > div {
    display: flex;
    flex-direction: row;
    align-items: center;
    gap: 1rem;
  }
</style>

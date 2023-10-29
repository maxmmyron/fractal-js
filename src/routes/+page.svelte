<script lang="ts">
  import { scale, x, y, cx, cy, view } from "$lib/stores";
  import { Canvas } from "@threlte/core";
  import Scene from "$lib/Scene.svelte";
  import Input from "$lib/components/Input.svelte";

  const reset = () => {
    scale.set(0);
    x.set(-1);
    y.set(0);
    cx.set(0);
    cy.set(0);
  };
</script>

<h1>
  Me when I draw the set of all points in the complex plane that do not diverge
  when recursively applied to the function f(z)=z<sup>2</sup>+c (with z starting
  at 0 and c being some point on the complex plane.)
</h1>
<section>
  <header>
    <h2>Controls</h2>
    <button on:click={reset}>Reset</button>
  </header>
  <fieldset>
    <legend>transform</legend>
    <Input store={x} min={-2} max={2} step={0.01}>X</Input>
    <Input store={y} min={-2} max={2} step={0.01}>Y</Input>
    <Input store={scale} min={0} max={100} step={0.01}>Zoom</Input>
  </fieldset>
  <fieldset>
    <legend>render</legend>
    <Input store={cx} min={-2} max={2} step={0.01}>X</Input>
    <Input store={cy} min={-2} max={2} step={0.01}>Y</Input>
    <br />
    <select bind:value={$view}>
      <option value="0" selected>Mandelbrot</option>
      <option value="1">Julia Shit</option>
    </select>
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

  section {
    display: flex;
    flex-wrap: wrap;
    margin-bottom: 2rem;
    gap: 0 16px;
  }

  section > header {
    width: 100%;
    display: flex;
    gap: 1rem;
    align-items: center;
  }

  section > header > button {
    height: fit-content;
  }

  fieldset {
    display: inline;
    width: fit-content;
  }
</style>

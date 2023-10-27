<script lang="ts">
  import { leftClamp, rightClamp, scale, x, y, precision } from "$lib/stores";
  import { Canvas } from "@threlte/core";
  import Scene from "$lib/Scene.svelte";
  import Input from "$lib/components/Input.svelte";
</script>

<h1>
  Me when I draw the set of all points in the complex plane that do not diverge
  when recursively applied to the function f(z)=z<sup>2</sup>+c (with z starting
  at 0 and c being some point on the complex plane.)
</h1>
<section>
  <h2>Controls</h2>
  <fieldset>
    <legend>Screen Clip</legend>
    <Input store={leftClamp} min={-5} max={0} step={0.1}>Left Clip</Input>
    <Input store={rightClamp} min={0} max={5} step={0.1}>Right Clip</Input>
  </fieldset>
  <fieldset>
    <legend>transform</legend>
    <Input store={x} min={-2} max={2} step={0.01}>X</Input>
    <Input store={y} min={-2} max={2} step={0.01}>Y</Input>
    <Input store={scale} min={0} max={100} step={0.01}>Zoom</Input>
  </fieldset>
  <fieldset>
    <legend>render options</legend>
    <Input store={precision} min={1} max={20} step={0.1}>Precision</Input>
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

  section > h2 {
    width: 100%;
  }

  fieldset {
    display: inline;
    width: fit-content;
  }
</style>

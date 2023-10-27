<script lang="ts">
  import { scale, x, y, precision } from "$lib/stores";
  import vertexShader from "$lib/shaders/vertex.glsl?raw";
  import fragmentShader from "$lib/shaders/fragment.glsl?raw";
  import { T } from "@threlte/core";
  import { interactivity } from "@threlte/extras";

  // i don't really understand why 7.68 fits the plane to the screen ¯\_(ツ)_/¯
  let planeScaling = 7.68;

  interactivity();
  const zoom = (e) => {
    console.log(e);
  };
</script>

<T.Mesh on:click={zoom}>
  <T.PlaneGeometry args={[1.6 * planeScaling, planeScaling]} />
  <T.ShaderMaterial
    {vertexShader}
    {fragmentShader}
    uniforms={{
      resolution: { value: [window.innerWidth, window.innerHeight] },
      scale: { value: 1.0 },
      position: { value: [0, 0] },
      prec: { value: 1.0 },
    }}
    uniforms.scale.value={$scale}
    uniforms.position.value={[$x, $y]}
    uniforms.prec.value={$precision}
  />
</T.Mesh>

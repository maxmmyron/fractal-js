<script lang="ts">
  import { leftClamp, rightClamp, scale, x, y, precision } from "$lib/stores";
  import vertexShader from "$lib/shaders/vertex.glsl?raw";
  import fragmentShader from "$lib/shaders/fragment.glsl?raw";
  import { T } from "@threlte/core";
  import { interactivity } from "@threlte/extras";

  interactivity();
  // i don't really understand why 7.68 fits the plane to the screen ¯\_(ツ)_/¯
  let planeScaling = 7.68;
</script>

<T.Mesh>
  <T.PlaneGeometry args={[1.6 * planeScaling, planeScaling]} />
  <T.ShaderMaterial
    {vertexShader}
    {fragmentShader}
    uniforms={{
      resolution: { value: [window.innerWidth, window.innerHeight] },
      leftClamp: { value: -3.4 },
      rightClamp: { value: 1.0 },
      scale: { value: 1.0 },
      position: { value: [0, 0] },
      prec: { value: 1.0 },
    }}
    uniforms.leftClamp.value={$leftClamp}
    uniforms.rightClamp.value={$rightClamp}
    uniforms.scale.value={$scale}
    uniforms.position.value={[$x, $y]}
    uniforms.prec.value={$precision}
  />
</T.Mesh>

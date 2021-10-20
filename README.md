# ppc-hole-ice-study
Studying the possibility of direct hole-ice propagation with the ppc photon propagator for the IceCube experiment

## Usage

### Firing Range

In this basic simulation, a flasher emits photons, and a receiver, which is one meter apart, counts incoming photon hits.

```shell
[2021-10-20 16:09:46] fiedl@icecube-ubuntu ~/ppc-hole-ice-study main
▶ rake firing_range
# => photons: 2720  hits: 869
```

### Varying hole-ice radius

In this simulation, a flasher emits photons, and a receiver, which is one meter apart, counts incoming photon hits. The hole-ice radius is varied and the number of hits is plotted against the hole-ice radius.

```
[2021-10-20 21:14:52] fiedl@icecube-ubuntu ~/ppc-hole-ice-study main
▶ rake firing_range_with_varying_hole_ice_radius
```

See also: [Issue #5](https://github.com/fiedl/ppc-hole-ice-study/issues/5)


## Installation

1. Setup the system and	icetray	as shown in [issue #1](https://github.com/fiedl/ppc-hole-ice-study/issues/1)
2. Clone this repository

   ```
   [2021-10-20 10:40:39] fiedl@icecube-ubuntu ~
   ▶ git clone git@github.com:fiedl/ppc-hole-ice-study.git
   ```

3. Run bundler to install the required ruby gem packages

   ```
   [2021-10-20 18:32:46] fiedl@icecube-ubuntu ~/ppc-hole-ice-study main
   ▶ bundle install
   ```

## Project Steps

Setup:

- [x] [Setup icetray on a new ubuntu 20.04 machine with gpu](https://github.com/fiedl/ppc-hole-ice-study/issues/1)
- [x] [Setup ppc standalone](https://github.com/fiedl/ppc-hole-ice-study/issues/2)
- [ ] [Setup project structure](https://github.com/fiedl/ppc-hole-ice-study/issues/3)
- [ ] [Learn about ppc configuration options](https://github.com/fiedl/ppc-hole-ice-study/issues/4)

Scientific:

- [ ] Angular acceptance: Check	if new hole ice	does the same as dima's	hole ice
- [ ] Circular scan: Check if new cable	does the same as dima's	cable
- [ ] Check performance
- [ ] Outline how to extend for	non-spherical detector modules

## Results

## Further Resources

- [icetray repository](https://github.com/icecube/icetray)
- [ppc source code](https://github.com/icecube/icetray/tree/main/ppc)
- [ppc documentation](https://github.com/icecube/icetray/blob/main/ppc/resources/docs/index.rst)

## Author and License

2021 Sebastian Fiedlschuster

MIT

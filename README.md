# The WE-Heraeus International Winter School on Gravity and Light

Lecture notes from the course delivered in 2015 by **Dr. Frederic P. Schuller** (Friedrich-Alexander-Universitat Erlangen-Nurnberg, Institut fur Theoretische Physik III). Notes taken by **Richie Dadhley**.

The course covers differential geometry and general relativity across 26 lectures, including topology, differentiable manifolds, tangent spaces, connections, curvature, spacetime, Einstein gravity, cosmology, black holes, and Penrose diagrams. Accompanying tutorial exercises are also included.

Video lectures are available on [YouTube](https://www.youtube.com/watch?v=7G4SqIboeig&t=3811s).

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/)
- [Make](https://www.gnu.org/software/make/) (pre-installed on most Linux/macOS systems)

No local LaTeX installation is required. The build runs inside a Docker container using the [`texlive/texlive`](https://hub.docker.com/r/texlive/texlive) image, which is pulled automatically on first build.

## Building

```sh
make
```

The output PDF is written to `build/main.pdf`.

### Other targets

| Command      | Description                                    |
|--------------|------------------------------------------------|
| `make`       | Build the PDF (only rebuilds if sources change)|
| `make clean` | Remove all build artifacts                     |
| `make shell` | Open a bash shell in the TeX container         |
| `make help`  | Show available targets and variables           |

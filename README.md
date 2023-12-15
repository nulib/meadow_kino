# Meadow.Kino

[Livebook](https://github.com/livebook-dev/livebook) Smart Cells for use with [Meadow](https://github.com/nulib/meadow). If you're not sure what that means, this repo probably isn't of any use to you.

## Installation

Add to a Meadow-connected Livebook by including the following in the *Reconnect and setup* block:

```elixir
Mix.install([
  {:meadow_kino, github: "nulib/meadow_kino"}
])
```
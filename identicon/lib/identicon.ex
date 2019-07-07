defmodule Identicon do
  @moduledoc """
  Create an image from a string.
  """

  @doc """
  Main function that calls the helper functions to transform string into an image. First three numbers turned into RGB value, for the main color.
  Then is assigned to a grid block, and if it is even, color white.
  If odd, assign color of our RGB. Grids are mirrored across middle grid.
  Main Grid is 5 x 5. Hash is 16 long. Use the first 15 elements of the hash.

  ## Examples

      iex> Identicon.main("Cows")
      :ok

  """
  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
    |> filter_odd_squares
    |> build_pixel_map
    |> draw_image
    |> save_image(input)

  end

  @doc """
  Saves the image held in memory to the current directory under the inputed filename.png.
  """
  def save_image(image, input) do
    File.write("#{input}.png", image)
  end

  @doc """
  Uses the pixel map and color from image struct to draw image in memory. Returns an image held in memory.
  """
  def draw_image(%Identicon.Image{color: color, pixel_map: pixel_map}) do
    image = :egd.create(250, 250)
    fill = :egd.color(color) #transforms our RGB into a color object

    Enum.each pixel_map, fn({start, stop}) ->
      :egd.filledRectangle(image, start, stop, fill)
    end

    :egd.render(image)
  end

  @doc """
  Creates a pixel map from the even squares, and appends it to image struct.
  """
  def build_pixel_map(%Identicon.Image{grid: grid} = image) do
    # each square is 50px. We must provide top right and bottom left points for each square.
    #Iteratre over each toupe, and produce x,y coords for each square-touple.
    pixed_map = Enum.map grid, fn({_code, index}) ->
      horizontal = rem(index, 5) * 50
      vertical = div(index, 5) * 50

      top_left = {horizontal, vertical}
      bottom_right = {horizontal + 50, vertical + 50}

     {top_left, bottom_right}
    end
    %Identicon.Image{image | pixel_map: pixed_map}
  end

  @doc """
  Transforms string into md5 hash list.
  Return value is struct with hex and color property.

  ## Examples

      iex> Identicon.hash_input("John")
      %Identicon.Image{
      color: nil,
      hex: [97, 64, 154, 161, 253, 71, 212, 165, 51, 45, 226, 60, 191, 89, 163, 111]
      }

  """
  def hash_input(input) do
    hex = :crypto.hash(:md5, input)
    |> :binary.bin_to_list

    %Identicon.Image{hex: hex}
  end

  @doc """
  Takes image struct, picks first three elemenents inside of hex list,and uses them to create an RGB defined color.
  Pattern match the image struct in the parameter to pull out first three elements.
  Adds the RGB to the image struct color field. Returns updated image struct.

  ## Examples

      iex> image = Identicon.hash_input("John")
      iex> Identicon.pick_color(image)
      %Identicon.Image{
      color: {97, 64, 154},
      hex: [97, 64, 154, 161, 253, 71, 212, 165, 51, 45, 226, 60, 191,89, 163, 111]
      }

  """
  def pick_color(%Identicon.Image{hex: [r, g, b | _tail]} = image) do
    #Create new image struct from original image struct and update color field as a touple.
    %Identicon.Image{image | color: {r, g, b}}
  end

  @doc """
  Takes 16 elements of the image, use Enum.chunk to transform into the 5x5 image grid, drops the last element, and then use the mirror_rows function to finalize the 5x5 grid.

  """
  def build_grid(%Identicon.Image{hex: hex} = image) do
    grid =
      hex
      |> Enum.chunk_every(3, 3, :discard)
      |> Enum.map(&mirror_row/1)
      |> List.flatten
      |> Enum.with_index

    %Identicon.Image{image | grid: grid}
  end

  @doc """
  Takes the 3x row, and then mirrors it around the third element, created a 5x row.

  ## Examples

      iex> Identicon.mirror_row([1, 2, 3])
      [1, 2, 3, 2, 1]

  """
  def mirror_row([first, second | _third] = row) do
    row ++ [second, first]
  end

  @doc """
  Filters out the odd squares from our grid
  """
  def filter_odd_squares(%Identicon.Image{grid: grid} = image) do
    # we are working with touples as elements of the grid
    grid = Enum.filter grid, fn ({code, _index}) ->
      rem(code, 2) == 0
    end

    %Identicon.Image{image | grid: grid}
  end

end

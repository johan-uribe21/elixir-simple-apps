defmodule Identicon do
  @moduledoc """
  Create an image from a string.
  """

  @doc """
  Main function that calls the helper functions to transform string into an image. Uses pipe operator to connect helper functions.
  First three numbers turned into RGB value, for our main color.
  Then is assigned to a grid block, and if it is even, color white.
  If odd, assign color of our RGB. Grids are mirrors across middle grid.
  Main Grid is 5 x 5. Hash is 16 long. Use the first 15 elements of the hash.


  ## Examples

      iex> Identicon.main(input)


  """
  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid

  end

  @doc """
  Transforms string into md5 hash list.
  Return value is struct with hex and color property.

  ## Examples

      iex> Identicon.hash_input("pet")
      [108, 67, 192, 168, 143, 191, 15, 68, 186, 148, 77, 0, 82, 78, 69, 195]

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
      iex> image = Identicon.hash_input("pet")
      iex> Identicon.pick_color(image)
      %Identicon.Image{
      color: {108, 67, 192},
      hex: [108, 67, 192, 168, 143, 191, 15, 68, 186, 148, 77, 0, 82, 78, 69,
      195]
      }

  """
  def pick_color(%Identicon.Image{hex: [r, g, b | _tail]} = image) do
    #Create new image struct from original image struct and update color field as a touple.
    %Identicon.Image{image | color: {r, g, b}}
  end

  @doc """
  Takes 16 elements of the image, use Enum.chunk to transform into the 5x5 image grid, drops the last element, and then mirroring the last two elements as the first two elements.

  ## Examples

      iex> Identicon.build_grid("pet")
      [108, 67, 192, 168, 143, 191, 15, 68, 186, 148, 77, 0, 82, 78, 69, 195]

  """
  def build_grid(image) do

  end
end

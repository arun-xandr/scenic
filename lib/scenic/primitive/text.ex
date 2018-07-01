#
#  Created by Boyd Multerer on 5/6/17.
#  Copyright © 2017 Kry10 Industries. All rights reserved.
#

defmodule Scenic.Primitive.Text do
  use Scenic.Primitive
  # alias Scenic.Primitive
#  alias Scenic.Primitive.Style


  @styles   [:hidden, :fill, :font, :font_size, :font_blur, :text_align, :text_height]


  #============================================================================
  # data verification and serialization

  #--------------------------------------------------------
  def info(), do: "Text data must be a bitstring: \"a_string\""

  #--------------------------------------------------------
  def verify( text ) when is_bitstring(text), do: {:ok, text}
  def verify( _ ), do: :invalid_data

  #============================================================================
  def valid_styles(), do: @styles

end
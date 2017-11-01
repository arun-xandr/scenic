#
#  Created by Boyd Multerer on 5/6/17.
#  Copyright © 2017 Kry10 Industries. All rights reserved.
#

defmodule Scenic.Primitive.Triangle do
  use Scenic.Primitive
  alias Scenic.Math
#  alias Scenic.Primitive
#  alias Scenic.Primitive.Style

  @styles   [:hidden, :color, :border_color, :border_width]


  #===========================================================================
  # data verification and serialization

  #--------------------------------------------------------
  def info(), do: "Triangle data must be three points, like this: {{x0,y0}, {x1,y1}, {x2,y2}}"

  def verify( {{x0, y0}, {x1, y1}, {x2, y2}} ) when
    is_number(x0) and is_number(y0) and
    is_number(x1) and is_number(y1) and
    is_number(x2) and is_number(y2), do: true
  def verify( _ ), do: false


  #--------------------------------------------------------
  def serialize( data, order \\ :native )
  def serialize( {{x0, y0}, {x1, y1}, {x2, y2}}, :native ) do
    { :ok,
      <<
        x0      :: integer-size(16)-native,
        y0      :: integer-size(16)-native,
        x1      :: integer-size(16)-native,
        y1      :: integer-size(16)-native,
        x2      :: integer-size(16)-native,
        y2      :: integer-size(16)-native,
      >>
    }
  end
  def serialize( {{x0, y0}, {x1, y1}, {x2, y2}}, :big ) do
    { :ok,
      <<
        x0      :: integer-size(16)-big,
        y0      :: integer-size(16)-big,
        x1      :: integer-size(16)-big,
        y1      :: integer-size(16)-big,
        x2      :: integer-size(16)-big,
        y2      :: integer-size(16)-big,
      >>
    }
  end

  #--------------------------------------------------------
  def deserialize( binary_data, order \\ :native )
  def deserialize( <<
      x0      :: integer-size(16)-native,
      y0      :: integer-size(16)-native,
      x1      :: integer-size(16)-native,
      y1      :: integer-size(16)-native,
      x2      :: integer-size(16)-native,
      y2      :: integer-size(16)-native,
      bin     :: binary
    >>, :native ) do
    {:ok, {{x0, y0}, {x1, y1}, {x2, y2}}, bin}
  end
  def deserialize( <<
      x0      :: integer-size(16)-big,
      y0      :: integer-size(16)-big,
      x1      :: integer-size(16)-big,
      y1      :: integer-size(16)-big,
      x2      :: integer-size(16)-big,
      y2      :: integer-size(16)-big,
      bin     :: binary
    >>, :big ) do
    {:ok, {{x0, y0}, {x1, y1}, {x2, y2}}, bin}
  end
  def deserialize( binary_data, order ), do: {:err_invalid, binary_data, order }

  #============================================================================
  def valid_styles(), do: @styles


  #--------------------------------------------------------
  def default_pin(data), do: centroid( data )

  #--------------------------------------------------------
  def centroid(data)
  def centroid({{x0, y0}, {x1, y1}, {x2, y2}}) do
    {
      round( (x0 + x1 + x2) / 3 ),
      round( (y0 + y1 + y2) / 3 )
    }
  end

  #--------------------------------------------------------
  # given three points, find the three points that expands
  # that triangle by a given width on each side.
  # General plan is this:
  # first, find three parallel lines that are moved outwards
  # by the width.
  # second, find the points that intersect those new lines.
  #
  # Special thanks to Mike Schacht, who is a math/physics wiz.
  # Seriously.
  #
  def expand( {p0, p1, p2}, width ) do
    # account for the winding of triangle
    cross = Math.Vector2.cross(
      Math.Vector2.sub(p1, p0),
      Math.Vector2.sub(p2, p0)
    )
    width = cond do
      cross < 0 -> -width
      true      -> width
    end
    
    # find the new parallel lines
    l01 = Math.Line.parallel( {p0, p1}, width )
    l12 = Math.Line.parallel( {p1, p2}, width )
    l20 = Math.Line.parallel( {p2, p0}, width )

    # calc the new poins from the intersections of the lines
    p0 = Math.Line.intersection( l01, l12 )
    p1 = Math.Line.intersection( l12, l20 )
    p2 = Math.Line.intersection( l20, l01 )

    # return the new triangle
    {p0, p1, p2}
  end

end
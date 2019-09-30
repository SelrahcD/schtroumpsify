defmodule SchtroumpsifyWeb.PageView do
  use SchtroumpsifyWeb, :view

  def toggle_class_if_not(className, map, key) do
    if !Map.get(map, key, :false) do
      className
    end
  end

  def toggle_class_if(className, map, key) do
    if Map.get(map, key, :false) do
      className
    end
  end
end

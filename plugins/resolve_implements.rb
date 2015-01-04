import 'org.bukkit.Bukkit'
import 'org.bukkit.inventory.ItemStack'
import 'org.bukkit.inventory.ShapelessRecipe'
import 'org.bukkit.Material'

module ResolveImprements
  extend self
  extend Rukkit::Util

  # convert String to Java char
  def char(str)
    str.ord
  end

  def resolve_iron_axe
    ShapelessRecipe.new(
      ItemStack.new(Material::IRON_INGOT, 1)
    ).add_ingredient(Material::IRON_AXE)
  end

  Bukkit.add_recipe(resolve_iron_axe)
end

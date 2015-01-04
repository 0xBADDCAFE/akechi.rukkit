import 'org.bukkit.Bukkit'
import 'org.bukkit.inventory.ItemStack'
import 'org.bukkit.inventory.ShapelessRecipe'
import 'org.bukkit.Material'

module ResolveImplements
  extend self
  extend Rukkit::Util

  # convert String to Java char
  def char(str)
    str.ord
  end

  def resolve_implements(material, implement)
    ShapelessRecipe.new(
      ItemStack.new(material, 1)
    ).add_ingredient(implement)
  end

  [
    # cobblestone
    [Material::COBBLESTONE, Material::STONE_AXE],
    [Material::COBBLESTONE, Material::STONE_HOE],
    [Material::COBBLESTONE, Material::STONE_PICKAXE],
    # [Material::COBBLESTONE, Material::STONE_SPADE],
    [Material::COBBLESTONE, Material::STONE_SWORD],
    # diamond
    [Material::DIAMOND, Material::DIAMOND_AXE],
    [Material::DIAMOND, Material::DIAMOND_BARDING],
    [Material::DIAMOND, Material::DIAMOND_BOOTS],
    [Material::DIAMOND, Material::DIAMOND_CHESTPLATE],
    [Material::DIAMOND, Material::DIAMOND_HELMET],
    [Material::DIAMOND, Material::DIAMOND_HOE],
    [Material::DIAMOND, Material::DIAMOND_LEGGINGS],
    [Material::DIAMOND, Material::DIAMOND_PICKAXE],
    # [Material::DIAMOND, Material::DIAMOND_SPADE],
    [Material::DIAMOND, Material::DIAMOND_SWORD],
    # gold ingot
    [Material::GOLD_INGOT, Material::GOLD_AXE],
    [Material::GOLD_INGOT, Material::GOLD_BARDING],
    [Material::GOLD_INGOT, Material::GOLD_BOOTS],
    [Material::GOLD_INGOT, Material::GOLD_CHESTPLATE],
    [Material::GOLD_INGOT, Material::GOLD_HELMET],
    [Material::GOLD_INGOT, Material::GOLD_HOE],
    [Material::GOLD_INGOT, Material::GOLD_LEGGINGS],
    [Material::GOLD_INGOT, Material::GOLD_PICKAXE],
    # [Material::GOLD_INGOT, Material::GOLD_SPADE],
    [Material::GOLD_INGOT, Material::GOLD_SWORD],
    # iron ingot
    [Material::IRON_INGOT, Material::IRON_AXE],
    [Material::IRON_INGOT, Material::IRON_BARDING],
    [Material::IRON_INGOT, Material::IRON_BOOTS],
    [Material::IRON_INGOT, Material::IRON_CHESTPLATE],
    [Material::IRON_INGOT, Material::IRON_HELMET],
    [Material::IRON_INGOT, Material::IRON_HOE],
    [Material::IRON_INGOT, Material::IRON_LEGGINGS],
    [Material::IRON_INGOT, Material::IRON_PICKAXE],
    # [Material::IRON_INGOT, Material::IRON_SPADE],
    [Material::IRON_INGOT, Material::IRON_SWORD],
    [Material::IRON_INGOT, Material::CHAINMAIL_BOOTS],
    [Material::IRON_INGOT, Material::CHAINMAIL_CHESTPLATE],
    [Material::IRON_INGOT, Material::CHAINMAIL_HELMET],
    [Material::IRON_INGOT, Material::CHAINMAIL_LEGGINGS],
    # leather
    [Material::LEATHER, Material::LEATHER_BOOTS],
    [Material::LEATHER, Material::LEATHER_CHESTPLATE],
    [Material::LEATHER, Material::LEATHER_HELMET],
    [Material::LEATHER, Material::LEATHER_LEGGINGS]
  ].each do |material, implement|
    Bukkit.add_recipe(resolve_implements(material, implement))
  end
end







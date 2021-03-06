# encoding: utf-8
=begin

A player in desert or mesa biome gets hurt by sunlight.
Sunlight doesn't hurt a player who is in the water/shade or equips helmet.
However, when a player equips an iron helmet, the player gets hurt more terribly.

TODO
* じっとしてる時に heatstroke のダメージ食らう <- すぐできなさそう
=end

import 'org.bukkit.Sound'
import 'org.bukkit.Material'
import 'org.bukkit.block.Biome'
import 'org.bukkit.Effect'

module Heatstroke
  extend self
  extend Rukkit::Util

  # constants {{{
  STRONG_SUNLIGHT = 14

  STRONG_SUNLIGHT_SPOT = [
    Biome::DESERT,
    Biome::DESERT_HILLS,
    Biome::DESERT_MOUNTAINS,
    Biome::MESA
  ]

  ALERT_TIME = 6

  DAMAGE_TIME = 15

  DAMAGE_INTERVAL = 3

  DAYTIME = 4000..11000

  IRON_HEAT_RATIO = 0.7

  IRON_ALERT_TIME = ALERT_TIME * IRON_HEAT_RATIO

  IRON_DAMAGE_TIME = DAMAGE_TIME * IRON_HEAT_RATIO

  IRON_DAMAGE_INTERVAL = DAMAGE_INTERVAL * IRON_HEAT_RATIO
  # }}}

  @need_to_escape ||= {}
  @player_info ||= {}
  @iron_helmet_equipped ||= false
  @player_equipped_iron_helmet ||= {}

  def on_player_move(evt) # {{{
    player = evt.player
    helmet = player.inventory.helmet

    head_guard = helmet && helmet.data.item_type != Material::IRON_HELMET

    if !@need_to_escape[player.name]
      @need_to_escape[player.name] = {
      "need_to_escape" => false
      }
    end

    if !STRONG_SUNLIGHT_SPOT.include?(player.location.block.biome)                       ||
       player.location.block.light_from_sky < STRONG_SUNLIGHT                            ||
       player.location.world.has_storm                                                   ||
       player.location.y < player.location.world.get_highest_block_at(player.location).y ||
       !DAYTIME.include?(player.world.get_time)                                          ||
       head_guard

      @player_info.delete(player.name)
      if @need_to_escape[player.name]["need_to_escape"]
         player.send_message "[HEATSTROKE] ご自愛ください"
         @need_to_escape[player.name]["need_to_escape"] = false
      end
      return
    end

    @need_to_escape[player.name]["need_to_escape"] = true
    @iron_helmet_equipped = !head_guard && helmet

    now = Time.now
    if !@player_info[player.name]
      @player_info[player.name] = {
        "alert" => @iron_helmet_equipped ? now+IRON_ALERT_TIME : now+ALERT_TIME,
        "alert_done" => false,
        "damage" => @iron_helmet_equipped ? now+IRON_DAMAGE_TIME : now+DAMAGE_TIME,
        "iron_eqquiped" => @iron_helmet_equipped
      }

      text = "[HEATSTROKE] ここはあついなー！！！！ 熱射病に気をつけましょう"
      text += "(鉄被ってると激ヤバです)" if @iron_helmet_equipped
      player.send_message text
      play_sound(player.location, Sound::FUSE, 1.0, 1.0)
    end

    @player_info[player.name]["iron_eqquiped"] = @iron_helmet_equipped

    if now > @player_info[player.name]["alert"] && !@player_info[player.name]["alert_done"]
      player.send_message "[HEATSTROKE] 炎天下でクラクラしてきました(涼しいところに逃げたり鉄でない何かをかぶる等しましょう)"
      @player_info[player.name]["alert_done"] = true
    elsif now > @player_info[player.name]["damage"] && player.health != 1

      @player_info[player.name]["damage"] = @player_info[player.name]["iron_eqquiped"] ? now+IRON_DAMAGE_INTERVAL : now+DAMAGE_INTERVAL

      player.set_health player.health-1
      play_sound(player.location, Sound::HURT_FLESH, 1.0, 1.0)
      play_effect(player.location, Effect::SMOKE, 0)
    end
  end # }}}

  def on_inventory_click(evt) # {{{
    player = evt.who_clicked

    if !STRONG_SUNLIGHT_SPOT.include?(player.location.block.biome)                       ||
       player.location.block.light_from_sky < STRONG_SUNLIGHT                            ||
       player.location.world.has_storm                                                   ||
       player.location.y < player.location.world.get_highest_block_at(player.location).y ||
       !DAYTIME.include?(player.world.get_time)
      @player_equipped_iron_helmet.delete(player.name)
      return
    end

    later 0 do
      hold_iron_helmet = evt.get_current_item.data.item_type == Material::IRON_HELMET

      # うーん@player_equipped_iron_helmetにiron helmetの有無を持たせるは適切なのかな
      # よくわからん
      @iron_helmet_equipped = player.inventory.armor_contents.to_a[-1].data.item_type == Material::IRON_HELMET
      if !@player_equipped_iron_helmet[player.name]
        @player_equipped_iron_helmet[player.name] = {
          "iron_eqquiped" => @iron_helmet_equipped
        }
      end
      @player_equipped_iron_helmet[player.name]["iron_eqquiped"] = @iron_helmet_equipped

      player.send_message "[HEATSTROKE] 鉄はヤバいって！！" if @player_equipped_iron_helmet[player.name]["iron_eqquiped"] && hold_iron_helmet
    end
  end # }}}
end

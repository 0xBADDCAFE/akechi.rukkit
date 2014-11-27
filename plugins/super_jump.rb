import 'org.bukkit.Sound'
import 'org.bukkit.Material'
import 'org.bukkit.util.Vector'

module SuperJump
  extend self
  extend Rukkit::Util

  def on_player_toggle_sneak(evt)
    player = evt.player
    return unless %w[world world_nether].include?(player.location.world.name)

    name = player.name
    @crouching_counter ||= {}
    @crouching_counter[name] ||= 0
    @crouching_countingdown ||= false
    if evt.sneaking?
      # counting up
      @crouching_counter[name] += 1
      later sec(1.5) do
        @crouching_counter[name] -= 1
      end
      if @crouching_counter[name] == 3
        loc = player.location
        play_sound(add_loc(loc, 0, 5, 0), Sound::BAT_TAKEOFF, 0.9, 0.0)

        # evt.player.send_message "superjump!"
        player.fall_distance = 0.0
        player.velocity = player.velocity.tap {|v| v.set_y jfloat(1.3) }
      end
    end
  end

  def on_player_interact(evt)
    player = evt.player
    return unless player.item_in_hand.type == Material::AIR
    return if player.on_ground?

    play_sound(add_loc(loc, 0, 5, 0), Sound::BAT_TAKEOFF, 0.5, 0.5)
    player.velocity = Vector(
      player.velocity.x * 2.0,
      player.velocity.y,
      player.velocity.z * 2.0)
  end
end

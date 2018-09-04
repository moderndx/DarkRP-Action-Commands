include("autorun/action_cmds_config.lua")

local function get_time_cur()
  local os_time = os.time()
  return os.date( "%H:%M:%S" , os_time )
end

local function fill_tags(output_chat, ply)
  if (string.find(output_chat,"{player_name}")) then
    output_chat = string.Replace( output_chat, "{player_name}", ply )
  end
  if (string.find(output_chat,"{time_cur}")) then
    output_chat = string.Replace( output_chat, "{time_cur}", get_time_cur() )
  end
  return output_chat
end

local function create_chat(chat_wanted_output, color, command)
  local expl = string.Explode(" ", chat_wanted_output)
  for k, v in _G["pairs"](expl) do
    if isstring(v) then expl[k] = v.." " end
    if (v == command) then
      table.insert( expl, k, color )
      table.insert( expl, k + 2, Color(255, 255, 255))
    end
  end
  table.insert(expl, 1, Color(255, 255, 255))
  return expl
end

_G["net"]["Receive"]("modern_timeout", function()
  local recieved_tbl = _G["net"]["ReadTable"]()
  chat.AddText("Please wait "..string.NiceTime(recieved_tbl.timeout_amount).." before using /"..recieved_tbl.command)
end)

_G["net"]["Receive"]("modern_action_cmd", function()
  local recieved_tbl = _G["net"]["ReadTable"]()
  local chat_msg = fill_tags(recieved_tbl["output"], recieved_tbl["player_name"])
  if (modern_action_commands_config.color_command) then
    local chat_tbl = create_chat(chat_msg, recieved_tbl["color"], recieved_tbl["command"])
    chat.AddText(unpack(chat_tbl))
  else
    chat.AddText(chat)
  end
end)

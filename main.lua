--[[============================================================================
main.lua
============================================================================]]--

-- Placeholder for the dialog
local dialog = nil

-- Placeholder to expose the ViewBuilder outside the show_dialog() function
local vb = nil

-- Reload the script whenever this file is saved. 
-- Additionally, execute the attached function.
_AUTO_RELOAD_DEBUG = function()
  
end

-- Read from the manifest.xml file.
class "RenoiseScriptingTool" (renoise.Document.DocumentNode)
  function RenoiseScriptingTool:__init()    
    renoise.Document.DocumentNode.__init(self) 
    self:add_property("Name", "Untitled Tool")
    self:add_property("Id", "Unknown Id")
  end

local manifest = RenoiseScriptingTool()
local ok,err = manifest:load_from("manifest.xml")
local tool_name = manifest:property("Name").value
local tool_id = manifest:property("Id").value



local MENU_NAME = "Main Menu:File:Export XM..."

--------------------------------------------------------------------------------
-- Main functions
--------------------------------------------------------------------------------

require 'XMWriter'

--------------------------------------------------------------------------------
-- GUI
--------------------------------------------------------------------------------


function saveXM() 
  local song = renoise.song()
  local writ = XMWriter(song)
  
  local outpath = renoise.app():prompt_for_filename_to_write("xm", "Save FastTracker XM file")
  writ:toFile(outpath)
end


--------------------------------------------------------------------------------
-- Menu entries
--------------------------------------------------------------------------------

renoise.tool():add_menu_entry {
  name = MENU_NAME,
  invoke = saveXM  
}


--------------------------------------------------------------------------------
-- Key Binding
--------------------------------------------------------------------------------

--[[
renoise.tool():add_keybinding {
  name = "Global:Tools:" .. tool_name.."...",
  invoke = show_dialog
}
--]]


--------------------------------------------------------------------------------
-- MIDI Mapping
--------------------------------------------------------------------------------

--[[
renoise.tool():add_midi_mapping {
  name = tool_id..":Show Dialog...",
  invoke = show_dialog
}
--]]

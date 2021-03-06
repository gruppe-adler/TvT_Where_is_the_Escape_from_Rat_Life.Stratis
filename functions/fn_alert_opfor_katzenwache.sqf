#include "..\script_component.hpp"

params [
    ["_alertedTrigger", objNull, [objNull]]
];

if (!(alive unit_indep_c)) exitWith {
    INFO("Katzenwachenalarm wird abgebrochen, Schlemihl lebt nicht mehr");
};
if (mission_state_katzenwache) exitWith {
    INFO("Katzenwachenalarm wird abgebrochen, wurde schon getriggert");
};
mission_state_katzenwache = true;

INFO("Katzenwachenalarm getriggert!");

{
	["Möglicherweise Katzenwache am Flugfeld. Alternative Fluchtmöglichkeit gefunden!"] call Mission_fnc_showHint;
	{ [_x] call Mission_fnc_createTaskIndepFlight; } forEach [getPos trigger_indep_spawn_boat_1, getPos trigger_indep_spawn_boat_2];

} remoteExec ["BIS_fnc_call", [RESISTANCE], true];

[
    [_alertedTrigger], 
    {
        params [
            ["_alertedTrigger", objNull, [objNull]]
        ];
        if (!(isNil "task_opfor_katzenwache")) then {
            ["Unsere Leute am Flughafen wurden entdeckt. Verdächtige Aktivität im Nordteil der Insel gemeldet. Wir fürchten, die Zielperson könnte von dort per Boot flüchten."] call Mission_fnc_showHint;
            {
                _x params [
                    ["_trigger", objNull, [objNull]],
                    ["_task", taskNull, [taskNull]]
                ];
                if (_trigger isEqualTo _alertedTrigger) then {
                    _task setTaskState "FAILED";
                } else {
                    _task setTaskState "CANCELED";
                };
                
            } forEach task_opfor_katzenwache;
        };
    }
] remoteExec ["BIS_fnc_call", [EAST, CIVILIAN], true];

#include "script_component.hpp"
/*
 * Author: jokoho482
 * Search pattern. Makes the unit ambush or creep closer to hostile players
 *
 * Arguments:
 * TODO
 *
 * Return Value:
 * TODO
 *
 * Example:
 * TODO
 *
 * Public: No
*/
params [["_mode", "", [""]], ["_input", [], [[]]]];

switch (_mode) do {
    // Default object init
    case "init": {
        _input params [["_logic", objNull, [objNull]], ["_isActivated", true, [true]], ["_isCuratorPlaced", false, [true]]];
        if !(_isActivated && local _logic) exitWith {};
        if (_isCuratorPlaced) then {
            //--- Get unit under cursor
            private _group = GET_CURATOR_GRP_UNDER_CURSOR;

            //--- Check if the unit is suitable
            private _error = "";
            if (isNull _group) then {
                _error = ELSTRING(main,NoUnitSelected);
            };

            if (_error == "") then {
                [LSTRING(Module_TaskCreep_DisplayName),
                    [
                        [LSTRING(Module_TaskCreep_Radius_DisplayName), "NUMBER", LSTRING(Module_TaskCreep_Radius_ToolTip), 1000],
                        [LSTRING(Module_TaskCreep_CycleTime_DisplayName), "NUMBER", LSTRING(Module_TaskCreep_CycleTime_ToolTip), 15],
                        [LSTRING(Module_TaskCreep_MovingCenter_DisplayName), "BOOLEAN", LSTRING(Module_TaskCreep_MovingCenter_ToolTip), true]
                    ], {
                        params ["_data", "_args"];
                        _args params ["_group", "_logic"];
                        _data params ["_range", "_cycle", "_movingCenter"];
                        if (_movingCenter) then {
                            [_group, _range, _cycle] spawn FUNC(taskCreep);
                        } else {
                            [_group, _range, _cycle, [], getPos _logic] spawn FUNC(taskCreep);
                        };
                        deleteVehicle _logic;
                    }, {
                        params ["", "_logic"];
                        deleteVehicle _logic;
                    }, {
                        params ["", "_logic"];
                        deleteVehicle _logic;
                    }, [_group, _logic]
                ] call EFUNC(main,showDialog);
            } else {
                [objNull, localize _error] call BIS_fnc_showCuratorFeedbackMessage;
                deleteVehicle _logic;
            };
        } else {
            private _groups = synchronizedObjects _logic apply {group _x};
            _groups = _groups arrayIntersect _groups;

            private _area = _logic getVariable ["objectarea",[]];
            private _range = _area select ((_area select 0) < (_area select 1));
            private _cycle = _logic getVariable [QGVAR(CycleTime), 4];
            private _movingCenter = _logic getVariable [QGVAR(MovingCenter), true];

            {
                if (_movingCenter) then {
                    [_x, _range, _cycle, _area] spawn FUNC(taskCreep);
                } else {
                    [_x, _range, _cycle, _area, getPos _logic] spawn FUNC(taskCreep);
                };
            } forEach _groups;
            deleteVehicle _logic;
        };
    };
};
true

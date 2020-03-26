#include "script_component.hpp"

params ["_logic", "", "_activated"];

if (_activated && local _logic) then {

    //--- Get unit under cursor
    private _unit = GET_CURATOR_UNIT_UNDER_CURSOR;

    //--- Check if the unit is suitable
    private _error = "";
    if (isNull _unit) then {
        _error = ELSTRING(main,NoUnitSelected);
    };
    if (isPlayer _unit) then {
        _error = ELSTRING(main,PlayerNotValid);
    };
    if (_error == "") then {
        [LSTRING(Module_DisableAI_DisplayName),
            [
                [LSTRING(Module_DisableAI_SettingName), "BOOLEAN", LSTRING(Module_DisableAI_SettingToolTip), _unit getVariable [QGVAR(disableAI), false]]
            ], {
                params ["_data", "_args"];
                _args params ["_unit", "_logic"];
                _data params ["_disableAI"];
                _unit setVariable [QGVAR(disableAI), _disableAI, true];
                deleteVehicle _logic;
            }, {
                params ["", "_logic"];
                deleteVehicle _logic;
            }, {
                params ["", "_logic"];
                deleteVehicle _logic;
            }, [_unit, _logic]
        ] call EFUNC(main,showDialog);
    } else {
        [objNull, localize _error] call BIS_fnc_showCuratorFeedbackMessage;
        deleteVehicle _logic;
    };
};

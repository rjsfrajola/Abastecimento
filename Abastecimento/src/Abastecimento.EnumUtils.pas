unit Abastecimento.EnumUtils;

interface

uses
  FMX.ListBox;

type
  {$SCOPEDENUMS ON}
  TBomba = (Gasolina, OleoDiesel);
  {$SCOPEDENUMS OFF}

  TBombaHelpers = record helper for TBomba
    function GetNomeCompleto: string;
    function GetNumber: integer;
  end;

  procedure EnumToComboBox(aComboBox: TComboBox);
  function GetBombaComboIndex(aID: integer): integer;

implementation

uses
  TypInfo;

{ TBombaHelpers }

procedure EnumToComboBox(aComboBox: TComboBox);
var
  LBomba: TBomba;
begin
  aComboBox.Clear;
  for LBomba := TBomba.Gasolina to TBomba.OleoDiesel do
    aComboBox.Items.Add(LBomba.GetNomeCompleto);
end;

function GetBombaComboIndex(aID: integer): integer;
begin
  case aID of
    1: Result := 0;
    2: Result := 1;
  end;
end;

function TBombaHelpers.GetNomeCompleto: string;
begin
  case Self of
    TBomba.Gasolina: Result := 'Gasolina';
    TBomba.OleoDiesel: Result := 'Oléo Diesel';
  end;
end;

function TBombaHelpers.GetNumber: integer;
begin
  case Self of
    TBomba.Gasolina: Result := 1;
    TBomba.OleoDiesel: Result := 2;
  end;
end;

end.

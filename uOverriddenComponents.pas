{*************************************************************************}
{                                                                         }
{ 1. Перерисовка фонового цвета TcxPageControl, TcxTabSheet, TcxScrollBox }
{ 2. Добавление хинта в комбобокс, и нектоторые мелкие фичи               }
{                                                                         }
{*************************************************************************}
unit uOverriddenComponents;

interface

uses
  cxGraphics, cxControls, cxLookAndFeels, cxHint, dxCustomHint, cxClasses,
  cxLookAndFeelPainters, cxContainer, cxEdit, dxSkinsCore, cxDropDownEdit,
  cxTextEdit, cxMaskEdit, cxImageComboBox, dxScreenTip, cxScrollBox, cxPC,
  cxTL,
  System.Classes, Vcl.ExtCtrls, System.SysUtils, System.Types, Vcl.Forms,
  Messages, Vcl.Graphics, Vcl.Controls, Math, Winapi.Windows;

const
  CONSTHINTDISPLAYPAUSE     = 100;
  CONSTHINTDISPLAYDURATION  = 2000;

type
  TcxTabSheetColored = class(TcxTabSheet)
  const
    NODEFINEDCOLOR = $8FFFFFFF;
  strict private
    procedure WndProc(var Message: TMessage); override;
  private
    FCustomColored: Boolean;
    FCustomColor: Int64;
  public
    property CustomColored: Boolean read FCustomColored write FCustomColored;
    property CustomColor: Int64 read FCustomColor write FCustomColor;
  published
    property AllowCloseButton;
    property BorderWidth;
    property Caption;
    property Color;
    property Constraints;
    property DragMode;
    property Enabled;
    property Font;
    property Height;
    property Highlighted;
    property ImageIndex;
    property Left;
    property PageIndex;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabHint;
    property TabVisible;
    property Top;
    property Visible;
    property Width;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnHide;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnShow;
    property OnStartDrag;
  end;

  TcxPageControlColored = class(TcxPageControl)
  const
    NODEFINEDCOLOR = $8FFFFFFF;
  strict private
    procedure WndProc(var Message: TMessage); override;
  private
    FCustomColored: Boolean;
    FCustomColor: Int64;
  public
    constructor Create(AOwner: TComponent); override;
    property CustomColored: Boolean read FCustomColored write FCustomColored;
    property CustomColor: Int64 read FCustomColor write FCustomColor;
  published
    property Align;
    property Anchors;
    property BiDiMode;
    property Color;
    property Constraints;
    property DockSite;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Focusable;
    property Font;
    property ParentBackground;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property Properties;
    property ActivePage;
    property HideTabs;
    property HotTrack;
    property ImageBorder;
    property Images;
    property LookAndFeel;
    property MultiLine;
    property NavigatorPosition;
    property Options;
    property OwnerDraw;
    property RaggedRight;
    property Rotate;
    property MaxRotatedTabWidth;
    property ScrollOpposite;
    property ShowFrame;
    property Style;
    property TabHeight;
    property TabPosition;
    property TabSlants;
    property TabWidth;
    property OnCanClose;
    property OnCanCloseEx;
    property OnChange;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDockDrop;
    property OnDockOver;
    property OnDragDrop;
    property OnDragOver;
    property OnDrawTab;
    property OnDrawTabEx;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetImageIndex;
    property OnGetTabHint;
    property OnGetSiteInfo;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnNew; // deprecated
    property OnNewTabButtonClick;
    property OnNewTabCreate;
    property OnPageChanging;
    property OnPaintDragImage;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
    property OnTabDragAndDrop;
    property OnTabEndDrag;
    property OnTabStartDrag;
    property OnUnDock;
  end;

  TcxPageControl = class(TcxPageControlColored)
  end;

  TcxTabSheet = class(TcxTabSheetColored)
  end;

  TScrollBoxColored = class(TcxScrollBox)
    procedure WndProc(var Message: TMessage); override;
  private
    FCustomColored: Boolean;
  public
    property CustomColored: Boolean read FCustomColored write FCustomColored;
  published
    property Align;
    property Anchors;
    property AutoScroll;
    property BiDiMode;
    property BorderStyle;
    property Color;
    property Cursor;
    property Enabled;
    property Font;
    property HelpContext;
    property HelpKeyword;
    property HelpType;
    property HorzScrollBar;
    property LookAndFeel;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Transparent;
    property VertScrollBar;
    property Visible;
    property OnCanResize;
    property OnClick;
    property OnConstrainedResize;
    property OnContextPopup;
    property OnDblClick;
    property OnEnter;
    property OnExit;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnResize;
  end;

  TcxScrollBox = class(TScrollBoxColored)
  end;

  TcxComboboxHint = class(TcxComboBox)
  private
    FTimerShow: TTimer;
    FTimerHide: TTimer;
    FHintStyleController: TcxHintStyleController;
    FPopupWindow: TcxComboBoxPopupWindow;
    FDestPoint: TPoint;
    FHint: string;
    FComboboxPropertiesPopupEvent: TNotifyEvent;
    FScrollHEnabled: Boolean;
    FHintOnlyOnHiddenText: Boolean;
    FX, FY: Integer;
    FManualTextUpdating: Boolean;
    function GetHintDisplayPause: Integer;
    procedure SetHintDisplayPause(aPause: Integer);
    function GetHintDisplayDuration: Integer;
    procedure SetHintDisplayDuration(aDuration: Integer);
    procedure TimerHideTimer(Sender: TObject);
    procedure TimerShowTimer(Sender: TObject);
    procedure DoComboBoxPropertiesPopup(Sender: TObject);
    procedure PopUpMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure PopUpMouseLeave(Sender: TObject);
    property PopupWindow;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure BeginUpdate;
    procedure EndUpdate;
    property ManualTextUpdating: Boolean read FManualTextUpdating write FManualTextUpdating;
    property ComboboxPropertiesPopup: TNotifyEvent read FComboboxPropertiesPopupEvent;
    property HintDisplayPause: Integer read GetHintDisplayPause write SetHintDisplayPause;
    property HintDisplayDuration: Integer read GetHintDisplayDuration write SetHintDisplayDuration;
    property ScrollHEnabled: Boolean read FScrollHEnabled write FScrollHEnabled;
    property HintOnlyOnHiddenText: Boolean read FHintOnlyOnHiddenText write FHintOnlyOnHiddenText;
  end;

  TcxComboBox = class(TcxComboBoxHint)
  end;

  TcxImageComboBoxHint = class(TcxImageComboBox)
  private
    FTimerShow: TTimer;
    FTimerHide: TTimer;
    FHintStyleController: TcxHintStyleController;
    FPopupWindow: TcxComboBoxPopupWindow;
    FDestPoint: TPoint;
    FHint: string;
    FComboboxPropertiesPopupEvent: TNotifyEvent;
    FScrollHEnabled: Boolean;
    FHintOnlyOnHiddenText: Boolean;
    FX, FY: Integer;
    function GetHintDisplayPause: Integer;
    procedure SetHintDisplayPause(aPause: Integer);
    function GetHintDisplayDuration: Integer;
    procedure SetHintDisplayDuration(aDuration: Integer);
    procedure TimerHideTimer(Sender: TObject);
    procedure TimerShowTimer(Sender: TObject);
    procedure DoComboBoxPropertiesPopup(Sender: TObject);
    procedure PopUpMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure PopUpMouseLeave(Sender: TObject);
    property PopupWindow;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property ComboboxPropertiesPopup: TNotifyEvent read FComboboxPropertiesPopupEvent;
    property HintDisplayPause: Integer read GetHintDisplayPause write SetHintDisplayPause;
    property HintDisplayDuration: Integer read GetHintDisplayDuration write SetHintDisplayDuration;
    property ScrollHEnabled: Boolean read FScrollHEnabled write FScrollHEnabled;
    property HintOnlyOnHiddenText: Boolean read FHintOnlyOnHiddenText write FHintOnlyOnHiddenText;
  end;

  TcxImageComboBox = class(TcxImageComboBoxHint)
  end;

  TTreeListHint = class
  strict private
    FTimerShow: TTimer;
    FTimerHide: TTimer;
    FHintStyleController: TcxHintStyleController;
    FDestPoint: TPoint;
    FX, FY: Integer;
    FHint: string;
    procedure TimerHideTimer(Sender: TObject);
    procedure TimerShowTimer(Sender: TObject);
  protected
    constructor Create;
    destructor Destroy;
  public
    Node: TcxTreeListNode;
    procedure ShowHint(aPoint: TPoint; aText: string);
    procedure HideHint;
  end;

var
  th: TTreeListHint;

implementation

uses uFragmentEditPanel, uPhantomPanelsForm, CERS.Secondary, uPointEditPane;

constructor TcxComboboxHint.Create(AOwner: TComponent);
begin
  inherited;
  Properties.OnPopup := DoComboBoxPropertiesPopup;
  FComboboxPropertiesPopupEvent := DoComboBoxPropertiesPopup;
  FHintStyleController := TcxHintStyleController.Create(nil);
  FHintStyleController.Global := False;
  FTimerShow := TTimer.Create(nil);
  FTimerShow.Enabled := False;
  FTimerShow.Interval := CONSTHINTDISPLAYPAUSE;
  FTimerShow.OnTimer := TimerShowTimer;
  FTimerHide := TTimer.Create(nil);
  FTimerHide.Enabled := False;
  FTimerHide.Interval := CONSTHINTDISPLAYDURATION;
  FTimerHide.OnTimer := TimerHideTimer;
  FScrollHEnabled := False;
  FHintOnlyOnHiddenText := True;
  FManualTextUpdating := False;
end;

destructor TcxComboboxHint.Destroy;
begin
  FreeAndNil(FTimerHide);
  FreeAndNil(FTimerShow);
  FreeAndNil(FHintStyleController);
  FPopupWindow := nil;
  inherited;
end;

procedure TcxComboboxHint.TimerHideTimer(Sender: TObject);
begin
  FTimerHide.Enabled := False;
  FPopupWindow.Hint := '';
  FHintStyleController.HideHint;
end;

procedure TcxComboboxHint.TimerShowTimer(Sender: TObject);
begin
  FTimerShow.Enabled := False;
  FTimerHide.Enabled := False;
  FHintStyleController.ShowHint(FDestPoint.X + 15, FDestPoint.Y - 10, '', FHint);
  FTimerHide.Enabled := True;
end;

procedure TcxComboboxHint.DoComboBoxPropertiesPopup(Sender: TObject);
begin
  TcxComboBoxListBox(PopupWindow.Controls[0]).OnMouseMove := PopUpMouseMove;
  if FManualTextUpdating then
    BeginUpdate;
end;

procedure TcxComboboxHint.BeginUpdate;
begin
  SendMessage(Self.Handle, WM_SETREDRAW, 0, 0);
end;

procedure TcxComboboxHint.EndUpdate;
begin
  SendMessage(Self.Handle, WM_SETREDRAW, 1, 0);
  Winapi.Windows.InvalidateRect(Self.Handle, nil, true);
  RedrawWindow(Self.Handle, nil, 0, RDW_ERASENOW or RDW_INVALIDATE or RDW_ALLCHILDREN);
end;

procedure TcxComboboxHint.PopUpMouseLeave(Sender: TObject);
begin
  FTimerShow.Enabled := False;
  FTimerHide.Enabled := False;
  FPopupWindow.Hint := '';
  FHintStyleController.HideHint;
end;

procedure TcxComboboxHint.PopUpMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  listBox: TcxComboBoxListBox;
  index: Integer;
begin
  if (X = FX) and (Y = FY) then
    Exit;
  FX := X;
  FY := Y;
  listBox := TcxEditListBoxContainer(Sender).InnerControl as TcxComboBoxListBox;
  listBox.OnMouseLeave := PopUpMouseLeave;
  if not FScrollHEnabled then
    listBox.ScrollWidth := 0;
  index := listBox.ItemAtPos(Point(X, Y), True);
  if index > -1 then
    begin
      FPopupWindow := TcxEditListBoxContainer(Sender).Parent as TcxComboBoxPopupWindow;
      FHint := TcxComboBox(FPopupWindow.Edit).Properties.Items[index];
      if FPopupWindow.Hint = FHint then
        Exit;
      FPopupWindow.Hint := FHint;
      FHintStyleController.HideHint;
      FDestPoint := FPopupWindow.ClientToScreen(Point(X, Y));
      if (listBox.Canvas.TextWidth(FHint) + 4 < listBox.ClientWidth) and FHintOnlyOnHiddenText then
        FTimerShow.Enabled := False
      else
        FTimerShow.Enabled := True;
    end
  else
    FHintStyleController.HideHint;
end;

function TcxComboboxHint.GetHintDisplayPause: Integer;
begin
  Result := FTimerShow.Interval;
end;

procedure TcxComboboxHint.SetHintDisplayPause(aPause: Integer);
begin
  FTimerShow.Interval := aPause;
end;

function TcxComboboxHint.GetHintDisplayDuration: Integer;
begin
  Result := FTimerHide.Interval;
end;

procedure TcxComboboxHint.SetHintDisplayDuration(aDuration: Integer);
begin
  FTimerHide.Interval := aDuration;
end;

constructor TcxImageComboBoxHint.Create(AOwner: TComponent);
begin
  inherited;
  Properties.OnPopup := DoComboBoxPropertiesPopup;
  FComboboxPropertiesPopupEvent := DoComboBoxPropertiesPopup;
  FHintStyleController := TcxHintStyleController.Create(nil);
  FHintStyleController.Global := False;
  FTimerShow := TTimer.Create(nil);
  FTimerShow.Enabled := False;
  FTimerShow.Interval := CONSTHINTDISPLAYPAUSE;
  FTimerShow.OnTimer := TimerShowTimer;
  FTimerHide := TTimer.Create(nil);
  FTimerHide.Enabled := False;
  FTimerHide.Interval := CONSTHINTDISPLAYDURATION;
  FTimerHide.OnTimer := TimerHideTimer;
  FScrollHEnabled := False;
  FHintOnlyOnHiddenText := True;
end;

destructor TcxImageComboBoxHint.Destroy;
begin
  FreeAndNil(FTimerHide);
  FreeAndNil(FTimerShow);
  FreeAndNil(FHintStyleController);
  FPopupWindow := nil;
  inherited;
end;

function TcxImageComboBoxHint.GetHintDisplayDuration: Integer;
begin
  Result := FTimerHide.Interval;
end;

function TcxImageComboBoxHint.GetHintDisplayPause: Integer;
begin
  Result := FTimerShow.Interval;
end;

procedure TcxImageComboBoxHint.TimerHideTimer(Sender: TObject);
begin
  FTimerHide.Enabled := False;
  FPopupWindow.Hint := '';
  FHintStyleController.HideHint;
end;

procedure TcxImageComboBoxHint.TimerShowTimer(Sender: TObject);
begin
  FTimerShow.Enabled := False;
  FTimerHide.Enabled := False;
  FHintStyleController.ShowHint(FDestPoint.X + 15, FDestPoint.Y - 10, '', FHint);
  FTimerHide.Enabled := True;
end;

procedure TcxImageComboBoxHint.DoComboBoxPropertiesPopup(Sender: TObject);
begin
  TcxComboBoxListBox(PopupWindow.Controls[0]).OnMouseMove := PopUpMouseMove;
end;

procedure TcxImageComboBoxHint.PopUpMouseLeave(Sender: TObject);
begin
  FTimerShow.Enabled := False;
  FTimerHide.Enabled := False;
  FPopupWindow.Hint := '';
  FHintStyleController.HideHint;
end;

procedure TcxImageComboBoxHint.PopUpMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  listBox: TcxComboBoxListBox;
  index: Integer;
begin
  if (X = FX) and (Y = FY) then
    Exit;
  FX := X;
  FY := Y;
  listBox := TcxEditListBoxContainer(Sender).InnerControl as TcxComboBoxListBox;
  listBox.OnMouseLeave := PopUpMouseLeave;
  if not FScrollHEnabled then
    listBox.ScrollWidth := 0;
  index := listBox.ItemAtPos(Point(X, Y), True);
  if index > -1 then
    begin
      FPopupWindow := TcxEditListBoxContainer(Sender).Parent as TcxComboBoxPopupWindow;
      FHint := TcxImageComboBox(FPopupWindow.Edit).Properties.Items[index].Description;
      if FPopupWindow.Hint = FHint then
        Exit;
      FPopupWindow.Hint := FHint;
      FHintStyleController.HideHint;
      FDestPoint := FPopupWindow.ClientToScreen(Point(X, Y));
      if (TcxImageComboBox(Sender).Canvas.TextWidth(FHint) + 4 < listBox.ClientWidth) and FHintOnlyOnHiddenText then
        FTimerShow.Enabled := False
      else
        FTimerShow.Enabled := True;
    end
  else
    FHintStyleController.HideHint;
end;

procedure TcxImageComboBoxHint.SetHintDisplayDuration(aDuration: Integer);
begin
  FTimerHide.Interval := aDuration;
end;

procedure TcxImageComboBoxHint.SetHintDisplayPause(aPause: Integer);
begin
  FTimerShow.Interval := aPause;
end;

procedure TScrollBoxColored.WndProc(var Message: TMessage);
begin
  inherited;
  if FCustomColored then
    if message.Msg = WM_PAINT then
      Self.Canvas.FillRect(Self.BoundsRect, COLOR_3B3E4E);
end;

constructor TcxPageControlColored.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCustomColor := NODEFINEDCOLOR;
end;

procedure TcxPageControlColored.WndProc(var Message: TMessage);
begin
  inherited;
  if FCustomColored then
    if message.Msg = WM_PAINT then
      Self.Canvas.FillRect(
          Rect(Self.ClientRect.Left,
               Self.ClientRect.Top + 26,
               Self.ClientRect.Right,
               Self.ClientRect.Bottom),
          IfTHen(FCustomColor = NODEFINEDCOLOR, COLOR_3B3E4E, FCustomColor));
end;

procedure TcxTabSheetColored.WndProc(var Message: TMessage);
begin
  inherited;
  if FCustomColored then
    if message.Msg = WM_ERASEBKGND then
      begin
        Self.Canvas.Brush.Color := IfTHen(FCustomColor = NODEFINEDCOLOR, COLOR_3B3E4E, FCustomColor);
        Self.Canvas.FillRect(Self.ClientRect);
      end;
end;

{ TTreeListHint }

constructor TTreeListHint.Create;
begin
  FHintStyleController := TcxHintStyleController.Create(nil);
  FHintStyleController.Global := False;
  FTimerShow := TTimer.Create(nil);
  FTimerShow.Enabled := False;
  FTimerShow.Interval := 1000;
  FTimerShow.OnTimer := TimerShowTimer;
  FTimerHide := TTimer.Create(nil);
  FTimerHide.Enabled := False;
  FTimerHide.Interval := 4000;
  FTimerHide.OnTimer := TimerHideTimer;
end;

destructor TTreeListHint.Destroy;
begin
  FreeAndNil(FTimerHide);
  FreeAndNil(FTimerShow);
  FreeAndNil(FHintStyleController);
end;

procedure TTreeListHint.HideHint;
begin
  FTimerShow.Enabled := False;
  FTimerHide.Enabled := False;
  FHintStyleController.HideHint;
end;

procedure TTreeListHint.ShowHint(aPoint: TPoint; aText: string);
begin
  if (aPoint.X = FX) and (aPoint.Y = FY) then
    Exit;
  FX := aPoint.X;
  FY := aPoint.Y;
  FHint := aText;
  FTimerShow.Enabled := True;
end;

procedure TTreeListHint.TimerHideTimer(Sender: TObject);
begin
  FTimerHide.Enabled := False;
  FHintStyleController.HideHint;
end;

procedure TTreeListHint.TimerShowTimer(Sender: TObject);
begin
  FTimerShow.Enabled := False;
  FTimerHide.Enabled := False;
  if FComponent.Visible then
    begin
      FHintStyleController.ShowHint(FX + 15, FY - 10, '', FHint);
      FTimerHide.Enabled := True;
    end;
end;

initialization
  th := TTreeListHint.Create;

finalization
  FreeAndNil(th);

end.

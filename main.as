[Setting name="Move InvertedSteeringWarning"]
bool Setting_MoveInvertedSteeringWarning = false;
[Setting name="Show InvertedSteeringWarning"]
bool Setting_ShowInvertedSteeringWarning = true;

[Setting name="Warn Color"]
vec4 Setting_WarnColor = vec4(1, 0, 0, 1);
[Setting name="Font Size"]
float Setting_FontSize = 64.0f;

[Setting name="Inversion Time Threshold (Milliseconds)"]
uint64 Setting_InvertedSteeringTimeThreshold = 300;


[Setting name="InvertedSteeringWarning X"]
int Setting_InvertedSteeringWarningX = 20;
[Setting name="InvertedSteeringWarning Y"]
int Setting_InvertedSteeringWarningY = 20;
[Setting name="InvertedSteeringWarning W"]
int Setting_InvertedSteeringWarningW = 600;
[Setting name="InvertedSteeringWarning H"]
int Setting_InvertedSteeringWarningH = 90;

uint64 TimeOfFirstInvert = 0;

void Main() {
}

void Render() {
    if (Setting_ShowInvertedSteeringWarning) {
        CSceneVehicleVisState@ state = VehicleState::ViewingPlayerState();
        if (state == null) return;

        bool isInverted =
            (state.InputSteer < 0 && (state.FLSteerAngle < 0 || state.FRSteerAngle < 0)) ||
            (state.InputSteer > 0 && (state.FLSteerAngle > 0 || state.FRSteerAngle > 0));

        if (isInverted && TimeOfFirstInvert == 0) {
            TimeOfFirstInvert = Time::get_Now();
        } else if (!isInverted) {
            // if (TimeOfFirstInvert != 0) {
            //     print("" + (Time::get_Now() - TimeOfFirstInvert));
            // }
            TimeOfFirstInvert = 0;
        }
        bool isInvertedLongerThanThreshold = isInverted && (Time::get_Now() - TimeOfFirstInvert) > Setting_InvertedSteeringTimeThreshold; 
        

        if (Setting_MoveInvertedSteeringWarning || isInvertedLongerThanThreshold) {
            // print("" + state.InputSteer);
            // print("" + state.FLSteerAngle);
            // print("" + state.FRSteerAngle);

            nvg::BeginPath();

            nvg::LoadFont("", true, true);
            nvg::FontSize(Setting_FontSize);
            nvg::FillColor(Setting_WarnColor);
            nvg::TextBox(
                Setting_InvertedSteeringWarningX,
                Setting_InvertedSteeringWarningY + Setting_FontSize,
                Setting_InvertedSteeringWarningW,
                "INVERTED STEERING"
            );

        nvg::ClosePath();
        }
    }

    if (!Setting_MoveInvertedSteeringWarning) return;
    UI::SetNextWindowSize(Setting_InvertedSteeringWarningW, Setting_InvertedSteeringWarningH, UI::Cond::Appearing);
    if (UI::Begin("Advanced Cam 2 Settings", Setting_MoveInvertedSteeringWarning, UI::WindowFlags::NoTitleBar)) {
        vec2 pos = UI::GetWindowPos();
        Setting_InvertedSteeringWarningX = pos.x;
        Setting_InvertedSteeringWarningY = pos.y;
        vec2 size = UI::GetWindowSize();
        Setting_InvertedSteeringWarningW = size.x;
        Setting_InvertedSteeringWarningH = size.y;
    }
    UI::End();
}
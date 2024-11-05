#include "flutter_window.h"

#include <optional>
#include <flutter/method_channel.h>
#include <flutter/standard_method_codec.h>
#include <flutter/encodable_value.h>

#include "flutter/generated_plugin_registrant.h"

FlutterWindow::FlutterWindow(const flutter::DartProject& project)
    : project_(project) {}

FlutterWindow::~FlutterWindow() {}

void FlutterWindow::ScheduleSleepTask() {
  // Placeholder: Add logic to schedule sleep task on Windows
  // For example, using Task Scheduler or `schtasks.exe`
  OutputDebugString(L"Sleep task scheduled.");
}

void FlutterWindow::ScheduleRestartTask() {
  // Placeholder: Add logic to schedule restart task on Windows
  OutputDebugString(L"Restart task scheduled.");
}

void FlutterWindow::CancelScheduledTasks() {
  // Placeholder: Add logic to cancel scheduled tasks on Windows
  OutputDebugString(L"Scheduled tasks canceled.");
}

bool FlutterWindow::OnCreate() {
    if (!Win32Window::OnCreate()) {
        return false;
    }

    RECT frame = GetClientArea();
    flutter_controller_ = std::make_unique<flutter::FlutterViewController>(
        frame.right - frame.left, frame.bottom - frame.top, project_);
    if (!flutter_controller_->engine() || !flutter_controller_->view()) {
        return false;
    }
    RegisterPlugins(flutter_controller_->engine());
    SetChildContent(flutter_controller_->view()->GetNativeWindow());

    // Create the MethodChannel for communication between Dart and native Windows
    auto channel = std::make_shared<flutter::MethodChannel<flutter::EncodableValue>>(
        flutter_controller_->engine()->messenger(),
        "com.example.task_scheduler",
        &flutter::StandardMethodCodec::GetInstance());

    // Set the MethodChannel's method call handler
    channel->SetMethodCallHandler(
        [this](const flutter::MethodCall<flutter::EncodableValue>& call,
               std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
            const std::string& method = call.method_name();

            if (method == "scheduleTask") {
                auto arguments = std::get<flutter::EncodableMap>(*call.arguments());
                auto taskType = std::get<std::string>(arguments[flutter::EncodableValue("taskType")]);
                auto time = std::get<std::string>(arguments[flutter::EncodableValue("time")]);
                
                if (taskType == "sleep") {
                    ScheduleSleepTask();
                } else if (taskType == "restart") {
                    ScheduleRestartTask();
                }
                result->Success();
            } else if (method == "cancelTasks") {
                CancelScheduledTasks();
                result->Success();
            } else {
                result->NotImplemented();
            }
        });

    flutter_controller_->engine()->SetNextFrameCallback([&]() { this->Show(); });
    flutter_controller_->ForceRedraw();

    return true;
}

void FlutterWindow::OnDestroy() {
    if (flutter_controller_) {
        flutter_controller_ = nullptr;
    }
    Win32Window::OnDestroy();
}

LRESULT FlutterWindow::MessageHandler(HWND hwnd, UINT const message, WPARAM const wparam, LPARAM const lparam) noexcept {
    // Handle window messages.
    if (flutter_controller_) {
        std::optional<LRESULT> result = flutter_controller_->HandleTopLevelWindowProc(hwnd, message, wparam, lparam);
        if (result) {
            return *result;
        }
    }

    switch (message) {
        case WM_FONTCHANGE:
            flutter_controller_->engine()->ReloadSystemFonts();
            break;
    }

    return Win32Window::MessageHandler(hwnd, message, wparam, lparam);
}

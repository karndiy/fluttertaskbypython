// #ifndef RUNNER_FLUTTER_WINDOW_H_
// #define RUNNER_FLUTTER_WINDOW_H_

// #include <flutter/dart_project.h>
// #include <flutter/flutter_view_controller.h>

// #include <memory>

// #include "win32_window.h"

// // A window that does nothing but host a Flutter view.
// class FlutterWindow : public Win32Window {
//  public:
//   // Creates a new FlutterWindow hosting a Flutter view running |project|.
//   explicit FlutterWindow(const flutter::DartProject& project);
//   virtual ~FlutterWindow();

//  protected:
//   // Win32Window:
//   bool OnCreate() override;
//   void OnDestroy() override;
//   LRESULT MessageHandler(HWND window, UINT const message, WPARAM const wparam,
//                          LPARAM const lparam) noexcept override;

//  private:
//   // The project to run.
//   flutter::DartProject project_;

//   // The Flutter instance hosted by this window.
//   std::unique_ptr<flutter::FlutterViewController> flutter_controller_;
// };

// #endif  // RUNNER_FLUTTER_WINDOW_H_

#pragma once

#include <flutter/dart_project.h>
#include <flutter/flutter_view_controller.h>

#include <memory>

#include "win32_window.h"

class FlutterWindow : public Win32Window {
 public:
  explicit FlutterWindow(const flutter::DartProject& project);
  virtual ~FlutterWindow();

  // Publicly accessible methods to schedule tasks
  void ScheduleSleepTask();
  void ScheduleRestartTask();
  void CancelScheduledTasks();

 protected:
  // Override window creation
  bool OnCreate() override;
  void OnDestroy() override;

 private:
  // Message handler for processing messages
  LRESULT MessageHandler(HWND hwnd, UINT const message, WPARAM const wparam, LPARAM const lparam) noexcept override;

  // Flutter controller and Dart project
  std::unique_ptr<flutter::FlutterViewController> flutter_controller_;
  flutter::DartProject project_;
};


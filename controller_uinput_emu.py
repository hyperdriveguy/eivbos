# controller_emulator.py

import sys
from PyQt6.QtWidgets import (
    QApplication, QMainWindow, QWidget, QVBoxLayout, QHBoxLayout, QComboBox,
    QPushButton, QLabel, QSlider, QSpinBox
)
from PyQt6.QtCore import Qt
import uinput


class ControllerEmulator(QMainWindow):
    def __init__(self):
        super().__init__()
        self.controllers = []
        self.current_controller_index = -1

        self.init_ui()

    def init_ui(self):
        self.setWindowTitle('Controller Emulator')
        self.central_widget = QWidget(self)
        self.setCentralWidget(self.central_widget)
        self.layout = QVBoxLayout(self.central_widget)

        # Dropdown for selecting controllers
        self.controller_combo = QComboBox(self)
        self.controller_combo.currentIndexChanged.connect(self.change_controller)
        self.layout.addWidget(self.controller_combo)

        # Buttons and joystick controls
        self.controls_layout = QVBoxLayout()
        self.button_grid = QVBoxLayout()

        self.buttons = {}
        for i, label in enumerate(['A', 'B', 'X', 'Y']):
            button = QPushButton(label, self)
            button.pressed.connect(self.handle_button_pressed)
            button.released.connect(self.handle_button_released)
            self.buttons[label] = button
            self.button_grid.addWidget(button)
        self.controls_layout.addLayout(self.button_grid)

        # Joystick sliders
        joystick_layout = QHBoxLayout()
        self.joystick_x_slider = QSlider(Qt.Orientation.Horizontal, self)
        self.joystick_x_slider.setRange(0, 255)
        self.joystick_x_slider.setValue(128)
        self.joystick_x_slider.valueChanged.connect(lambda value: self.update_axis("X", value))
        joystick_layout.addWidget(QLabel('Joystick X:'))
        joystick_layout.addWidget(self.joystick_x_slider)
        self.joystick_x_spinbox = QSpinBox(self)
        self.joystick_x_spinbox.setRange(0, 255)
        self.joystick_x_spinbox.setValue(128)
        self.joystick_x_spinbox.valueChanged.connect(self.joystick_x_slider.setValue)
        self.joystick_x_slider.valueChanged.connect(self.joystick_x_spinbox.setValue)
        joystick_layout.addWidget(self.joystick_x_spinbox)

        self.joystick_y_slider = QSlider(Qt.Orientation.Vertical, self)
        self.joystick_y_slider.setRange(0, 255)
        self.joystick_y_slider.setValue(128)
        self.joystick_y_slider.valueChanged.connect(lambda value: self.update_axis("Y", value))
        joystick_layout.addWidget(QLabel('Joystick Y:'))
        joystick_layout.addWidget(self.joystick_y_slider)
        self.joystick_y_spinbox = QSpinBox(self)
        self.joystick_y_spinbox.setRange(0, 255)
        self.joystick_y_spinbox.setValue(128)
        self.joystick_y_spinbox.valueChanged.connect(self.joystick_y_slider.setValue)
        self.joystick_y_slider.valueChanged.connect(self.joystick_y_spinbox.setValue)
        joystick_layout.addWidget(self.joystick_y_spinbox)

        self.controls_layout.addLayout(joystick_layout)
        self.layout.addLayout(self.controls_layout)

        # Add/Remove controller buttons
        add_remove_layout = QHBoxLayout()
        add_button = QPushButton('Add Controller', self)
        add_button.clicked.connect(self.add_controller)
        remove_button = QPushButton('Remove Controller', self)
        remove_button.clicked.connect(self.remove_controller)
        add_remove_layout.addWidget(add_button)
        add_remove_layout.addWidget(remove_button)
        self.layout.addLayout(add_remove_layout)

    def add_controller(self):
        events = [
            uinput.ABS_X + (0, 255, 0, 0),
            uinput.ABS_Y + (0, 255, 0, 0),
            uinput.BTN_A, uinput.BTN_B, uinput.BTN_X, uinput.BTN_Y
        ]
        controller = uinput.Device(events)
        self.controllers.append(controller)
        self.controller_combo.addItem(f'Controller {len(self.controllers)}')
        self.controller_combo.setCurrentIndex(len(self.controllers) - 1)

    def remove_controller(self):
        if self.current_controller_index != -1:
            del self.controllers[self.current_controller_index]
            self.controller_combo.removeItem(self.current_controller_index)
            self.current_controller_index = self.controller_combo.currentIndex()

    def change_controller(self, index):
        self.current_controller_index = index

    def handle_button_pressed(self):
        sender = self.sender()
        label = sender.text().replace("&", "")  # Remove the & from button text
        if self.current_controller_index == -1:
            return

        try:
            event = getattr(uinput, f'BTN_{label}')
        except AttributeError:
            print(f"Error: Button {label} not found in uinput!")
            return

        # Emit press event
        self.controllers[self.current_controller_index].emit(event, 1)

    def handle_button_released(self):
        sender = self.sender()
        label = sender.text().replace("&", "")  # Remove the & from button text
        if self.current_controller_index == -1:
            return

        try:
            event = getattr(uinput, f'BTN_{label}')
        except AttributeError:
            print(f"Error: Button {label} not found in uinput!")
            return

        # Emit release event
        self.controllers[self.current_controller_index].emit(event, 0)


    def update_axis(self, axis, value):
        if self.current_controller_index == -1:
            return
        event = uinput.ABS_X if axis == "X" else uinput.ABS_Y
        self.controllers[self.current_controller_index].emit(event, value)


if __name__ == '__main__':
    app = QApplication(sys.argv)
    emulator = ControllerEmulator()
    emulator.show()
    sys.exit(app.exec())

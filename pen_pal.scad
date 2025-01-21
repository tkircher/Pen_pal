// Remix of Henry Arnold's DrawBot v1.1
//
// Thomas Kircher <tkircher@gnu.org>, 2024-2025
//
// While the round rod and threaded rod motif has been played out, this is still a
// decent, simple design.

saddle_l = 102.0;
saddle_w = 77.0;
saddle_t = 4.0;

saddle_mount_l = saddle_l - 10;
saddle_mount_w = saddle_w - 10;

standoff_d = 3.1 + 2 * 0.4 * 6;

module roofus() {
  scale([1.25, 1.25, 1.0])
  translate([-23, -20, 0])
  linear_extrude(height = 0.6 + 0.1)
    import("RoofusMilton.svg");
}

// External STLs
module driver_PCB() {
  color("lightblue")
  translate([-70 / 2, -70 / 2, 0])
    import("FluidNC_board.stl");
}

module sg90_servo(angle = 90) {
  translate([-13.35, -35.25, -55.55])
    import("SG90_micro_servo.stl");

  translate([-10.30 / 2, 0, 0])
  rotate([0, angle, 0])
  translate([-1.525, -18.8, -55.55 / 2])
    import("SG90_micro_servo_arm.stl");

}

module torus(r1, r2) {
  rotate_extrude(convexity = 10, $fn = 160)
  translate([r1 / 2, 0, 0])
    circle(r = r2, $fn = 60);
}

// ----------------------------------------------------------------------------------
// X axis parts

module x_axis_block(controller = false) {
  difference() {
    union() {
      // Main body
      translate([-2, -95 / 2, 0])
        cube([50 + 2, 95, 10]);

      // Stepper motor section
      translate([-2, 0, -46])
      difference() {
        union() {
          translate([0, -(42 + 9) / 2, 0])
            cube([6, 42 + 9, 52]);

          // Motor plate supports
          for(i = [-1 : 2 : 1])
          translate([0, i * (42 + 10 / 2) / 2 - 4 / 2, 0])
          difference() {
            union() {
              cube([20, 4, 52]);

              // Chamfer the inner corner
              translate([20, 0, 46])
              rotate([0, 45, 0])
                translate([-8 / 2, 0, -8 / 2])
                  cube([8, 4, 8]);

            }

            // Chamfer the ends
            translate([21, -1, 0])
            rotate([0, 45, 0])
              translate([-16 / 2, 0, -16 / 2])
                cube([16, 6, 16]);
          }

          // Side chamfers
          for(i = [-1 : 2 : 1])
          translate([0, i * 50 / 2, 50 - 8 / 2])
          rotate([45, 0, 0])
            translate([0, -8 / 2, -8 / 2])
            cube([6, 8, 8]);
        }

        translate([-1, 0, 21]) {
          // Center cutout
          rotate([0, 90, 0])
            cylinder(d = 24, h = 10, $fn = 200);

          // Stepper mount hole cutouts
          for(i = [-1 : 2 : 1])
          for(j = [-1 : 2 : 1]) {
            translate([0, i * 31 / 2, j * 31 / 2])
            rotate([0, 90, 0]) {
              cylinder(d = 3.3, h = 10, $fn = 90);

              translate([0, 0, 6 + 1 - 3])
              cylinder(d = 5.8, h = 3 + 1, $fn = 120);
            }
          }
        }
      }

      // CNC controller mount section
      if(controller == true) {
        mount_w = 26;

        translate([0, -47.5, -20 + 10])
        difference() {
          union() {
            cube([mount_w, 4, 20]);

            // Lower chamfers
            for(i = [-1 : 2 : 1]) {
              translate([i * (mount_w / 2) + mount_w / 2, 0, 10])
              rotate([0, 45, 0])
              translate([-(4 / sqrt(2)) / 2, 0, -(4 / sqrt(2)) / 2])
                cube([4 / sqrt(2), 4, 4 / sqrt(2)]);
            }
          }

          // Mount holes and hex nut seats
          for(i = [-1 : 2 : 1]) {
            translate([mount_w / 2 + i * (mount_w / 2 - 7), 4 + 0.1, 10 / 2])
            rotate([90, 0, 0])
            rotate([0, 0, 30]) {
              cylinder(d = 3.2, h = 50, $fn = 90);

              cylinder(d = 5.8 / (sqrt(3) / 2), h = 1.8 + 0.1, $fn = 6);
            }
          }

          // Upper chamfers
          for(i = [-1 : 2 : 1]) {
            translate([i * (mount_w / 2 + 1.5) + mount_w / 2, -1, -1.5])
            rotate([0, 45, 0])
            translate([-8 / 2, 0, -8 / 2])
              cube([8, 6, 8]);
          }
        }
      }
    }

    // Main cutouts
    translate([80 / 2, 0, 0]) {
      // Arch cutout
      translate([72, 0, -1])
        cylinder(d = 140, h = 12, $fn = 300);

      // Linear rod cutouts
      for(i = [-1 : 2 : 1]) {
        translate([-24, i * 35, -1]) {
          cylinder(d = 8 + 0.15, h = 12, $fn = 120);

          // Rod setscrews
          translate([-1, 0, 6]) {
            rotate([0, -90, 0])
              cylinder(d = 3 + 0.15, h = 50, $fn = 90);

            translate([-10.5 + 2.4, 0, 0])
            rotate([0, -90, 0])
              cylinder(d = 5.9 / (sqrt(3) / 2), h = 2.4, $fn = 6);

            translate([-10.5, -5.9 / 2, -12])
              cube([2.4, 5.9, 12]);
          }
        }
      }

      // Threaded rod cutout
      translate([-5, 0, -1])
        cylinder(d = 8.1, h = 12, $fn = 120);

      // Belt clearance cutouts
      translate([-36, -24 / 2, -25])
        cube([18, 24, 40]);

      // Endstop cutouts and hex nut seats
      for(i = [-1 : 2 : 1]) {
        translate([-16.25 + 3.0, i * 4.75, 2.5])
        rotate([0, -90, 0]) {
          translate([0, 0, -2.4])
            cylinder(d = 2.1, h = 30, $fn = 60);

          translate([-15, -4.1 / 2, 0])
            cube([15, 4.1, 1.8]);

          cylinder(d = 4.1 / (sqrt(3) / 2), h = 1.8, $fn = 6);

          translate([0, 0, 18])
            cylinder(d = 5, h = 16, $fn = 90);
        }
      }

      // Compatibility mounting hole cutouts
      for(i = [-1 : 2 : 1]) {
        translate([5, i * 42.5, -1])
          cylinder(d = 4, h = 12, $fn = 90);
      }

      translate([-17, 17.5, -1])
        cylinder(d = 4, h = 12, $fn = 90);
    }

    // Outer fillets
    translate([48 / 2, 0, 0])
    for(i = [0 : 1])
    for(j = [0 : 1]) {
      mirror([i, 0, 0])
      mirror([0, j, 0])
      if((controller != true) || ((i != 1) || (j != 1))) {
        translate([52 / 2, 95 / 2, -0.1])
        difference() {
          translate([-10 / 2, -10 / 2, 0])
            cube([10, 10, 12]);

          translate([-10 / 2, -10 / 2, -0.1])
            cylinder(d = 10, h = 12 + 2, $fn = 160);
        }
      }
    }
  }
}

// The FluidNC driver case
case_w = 86;
case_l = 106;
case_t = 0.6 * 6;

board_x = -4.2;
board_y = 2.5 + 4.6;

board_w = 70;
board_l = 70;

// Using PCB coordinates
PCB_holes = [[113, 137], [136, 107], [167, 137], [113, 73], [167, 73]];

// Case mount holes, [x, y, rot]
case_standoff = [[-case_w / 2 + 6, -case_l / 2 + 6, 180],
                 [-case_w / 2 + 6,  case_l / 2 - 6, 90],
                 [case_w / 2 - 15, -case_l / 2 + 6, 0],
                 [ case_w / 2 - 6,  case_l / 2 - 6, 0]];

module driver_case_bottom() {
  wall_h = 15;

  difference() {
    union() {
      // Base
      translate([-case_w / 2, -case_l / 2, 0])
        cube([case_w, case_l, case_t]);

      // PCB standoffs
      translate([board_x, board_y, 0])
      for(i = [0 : len(PCB_holes) - 1]) {
        translate([-110 - board_w / 2, 140 - board_l / 2, 0])
        translate([PCB_holes[i][0], -PCB_holes[i][1], 0])
          cylinder(d = 3.4 + 2 * 0.4 * 4, h = case_t + 3.6, $fn = 90);
      }

      // Top case mount standoffs
      standoff_d = 3.4 + 2 * 0.4 * 4;

      for(i = [0 : 3]) {
        translate([case_standoff[i][0], case_standoff[i][1], 0])
        rotate([0, 0, case_standoff[i][2]])
          cylinder(d = standoff_d, h = case_t + 3, $fn = 90);
      }

      // Side walls
      for(i = [0 : 1]) {
        mirror([i, 0, 0])
        translate([-case_w / 2, -case_l / 2, 0])
          cube([0.4 * 5, case_l, wall_h]);
      }

      translate([-case_w / 2, -case_l / 2, 0])
        cube([case_w, 0.4 * 5, wall_h]);

      translate([-case_w / 2, case_l / 2 - 0.4 * 5, 0])
        cube([case_w, 0.4 * 5, wall_h]);

      // Inner fillets
      for(i = [0 : 1])
      for(j = [0 : 1]) {
        mirror([i, 0, 0])
        mirror([0, j, 0]) {
          translate([case_w / 2 - 10 / 2, case_l / 2 - 10 / 2, 0]) {
            difference() {
              cylinder(d = 10, h = wall_h, $fn = 160);

              translate([0, 0, -0.1])
                cylinder(d = 10 - 2 * 0.4 * 5, h = wall_h + 2, $fn = 160);

              translate([-10, -10 / 2 - 0.4 * 5, -0.1])
                cube([10, 10, 20]);

              translate([-10 / 2 - 0.4 * 5, -10, -0.1])
                cube([10, 10, 20]);
            }
          }
        }
      }
    }

    // Top case mount holes
    for(i = [0 : 3]) {
      translate([case_standoff[i][0], case_standoff[i][1], -1])
      rotate([0, 0, case_standoff[i][2]]) {
        cylinder(d = 3.4, h = case_t + 5, $fn = 90);

        cylinder(d = 5.8 / (sqrt(3) / 2), h = 2.4 + 1, $fn = 6);

        translate([0, 0, 2.4 + 1])
          cylinder(d1 = 5.8 / (sqrt(3) / 2), d2 = 3.4, h = 1.8, $fn = 6);
      }
    }

    translate([board_x, board_y, 0]) {
      // PCB mount holes
      for(i = [0 : len(PCB_holes) - 1]) {
        translate([-110 - board_w / 2, 140 - board_l / 2, 0])
        translate([PCB_holes[i][0], -PCB_holes[i][1], -0.1]) {
          cylinder(d = 3.4, h = case_t + 3.6 + 1, $fn = 90);

          cylinder(d = 5.8 / (sqrt(3) / 2), h = 2.4 + 0.1, $fn = 6);

          translate([0, 0, 2.4 + 0.1])
            cylinder(d1 = 5.8 / (sqrt(3) / 2), d2 = 3.4, h = 1.8, $fn = 6);
        }
      }

      // USB and SD card cutout
      translate([-70 / 2 - 26.5, -5, case_t]) {
        difference() {
          cube([25, 35, case_t + wall_h + 1]);

          for(i = [0 : 1]) {
            translate([-1, i * (35 + 2) - 1, -3])
            rotate([45, 0, 0])
            translate([0, -8 / 2, -8 / 2])
              cube([27, 8, 8]);
          }
        }
      }

      // Digital input and output side cutouts
      translate([70 / 2 + 1.5, -31.5, case_t + 1.8]) {
        difference() {
          cube([25, 65.5, case_t + wall_h + 1]);

          for(i = [0 : 1]) {
            translate([-1, i * (65.5 + 2) - 1, -3])
            rotate([45, 0, 0])
            translate([0, -8 / 2, -8 / 2])
              cube([27, 8, 8]);
          }
        }
      }

      // Digital input bottom cutout, for endstop wires
      slot_w = 6;
      slot_l = 21.5;

      translate([70 / 2 + 5, slot_l / 2 - 2, -1]) {
        for(i = [0 : 1])
        for(j = [0 : 1]) {
          mirror([i, 0, 0])
          mirror([0, j, 0]) {
            translate([slot_w / 2 - 3 / 2, slot_l / 2 - 3 / 2, 0])
              cylinder(d = 3, h = 10, $fn = 60);
          }
        }

        translate([-slot_w / 2 + 3 / 2, -slot_l / 2, 0])
          cube([slot_w - 3, slot_l, 10]);

        translate([-slot_w / 2, -slot_l / 2 + 3 / 2, 0])
          cube([slot_w, slot_l - 3, 10]);
      }

      // Heatsink cutouts
      heatsink_x = [124, 142];

      for(n = [0 : 1]) {
        translate([-110 - board_w / 2 + heatsink_x[n],
                    140 - board_l / 2 - 123, -0.1]) {
          for(i = [0 : 1])
          for(j = [0 : 1]) {
            mirror([i, 0, 0])
            mirror([0, j, 0]) {
              translate([10 / 2 - 3 / 2, 10 / 2 - 3 / 2, -0.1])
                cylinder(d = 3, h = 20, $fn = 60);
            }
          }

          translate([-10 / 2 + 3 / 2, -10 / 2, 0])
            cube([10 - 3, 10, 20]);

          translate([-10 / 2, -10 / 2 + 3 / 2, 0])
            cube([10, 10 - 3, 20]);
        }
      }
    }

    // Outer fillets
    for(i = [0 : 1])
    for(j = [0 : 1]) {
      mirror([i, 0, 0])
      mirror([0, j, 0]) {
        translate([case_w / 2, case_l / 2, -0.1])
        difference() {
          translate([-10 / 2, -10 / 2, 0])
            cube([10, 10, case_t + wall_h + 1]);

          translate([-10 / 2, -10 / 2, -0.1])
            cylinder(d = 10, h = case_t + wall_h + 2, $fn = 160);
        }
      }
    }

    // Base mount holes
    for(i = [0 : 1]) {
      translate([case_w / 2 - 15, i * 12 - 24 + 0.05, -1]) {
        cylinder(d = 3.2, h = 12, $fn = 90);

        translate([0, 0, 2.2])
        cylinder(d = 5.8, h = 2.4 + 0.1, $fn = 120);
      }
    }

    // Motor and power cutouts and zip tie slots
    for(i = [0 : 1]) {
      translate([-4.5 + board_x - i * 16, -(case_w / 2 - 1) - 7 / 2, -1]) {
        cylinder(d = 7, h = 80, $fn = 100);

        translate([-7 / 2, -7 / 2, 0])
          cube([7, 7 / 2, 7]);

        for(j = [-1 : 2 : 1])
        translate([j * 2 - 1.2 / 2, 6, -1])
          cube([1.2, 3, 8]);
      }
    }

    // DC plug mount
    translate([case_w / 2 - 34.5, -44, -1]) {
      cylinder(d = 8, h = 8, $fn = 120);

      translate([0, 0, 3.6 + 1 - 1.8])
      cylinder(d = 11.2, h = 2, $fn = 160);
    }
  }
}

module driver_case_top() {
  wall_h = 12;

  mirror([0, 0, 1])
  difference() {
    union() {
      // Base
      translate([-case_w / 2, -case_l / 2, 0])
        cube([case_w, case_l, case_t]);

      // Bottom case mount standoffs
      standoff_d = 3.4 + 2 * 0.4 * 4;

      for(i = [0 : 3]) {
        translate([case_standoff[i][0], case_standoff[i][1], 0])
        rotate([0, 0, case_standoff[i][2]])
          if(i != 2) {
            cylinder(d = standoff_d, h = wall_h + 1.2, $fn = 90);

            translate([0, -standoff_d / 2, 0])
              cube([standoff_d / 2 + 0.6, standoff_d / 2, wall_h + 1.2]);

            translate([-standoff_d / 2, 0, 0])
              cube([standoff_d / 2, standoff_d / 2 + 0.6, wall_h + 1.2]);
          }
          // The odd one out
          else {
            cylinder(d = standoff_d, h = wall_h + 1.2, $fn = 90);

            translate([-standoff_d / 2, -standoff_d / 2 - 1, 0])
              cube([standoff_d, standoff_d / 2 + 1, wall_h]);

            translate([-standoff_d / 2, -standoff_d / 2 - 0.6, 0])
              cube([standoff_d, standoff_d / 2 + 0.6, wall_h + 1.2]);
          }
      }

      // Side walls
      for(i = [0 : 1]) {
        mirror([i, 0, 0])
        translate([-case_w / 2, -case_l / 2, 0])
          cube([0.4 * 5, case_l, wall_h]);
      }

      translate([-case_w / 2, -case_l / 2, 0])
        cube([case_w, 0.4 * 5, wall_h]);

      translate([-case_w / 2, case_l / 2 - 0.4 * 5, 0])
        cube([case_w, 0.4 * 5, wall_h]);

      tab_d = (10 - 2 * 0.4 * 5) - 0.2;

      // Inner fillets and case alignment tabs
      for(i = [0 : 1])
      for(j = [0 : 1]) {
        mirror([i, 0, 0])
        mirror([0, j, 0]) {

          translate([case_w / 2 - 10 / 2, case_l / 2 - 10 / 2, 0]) {
            difference() {
              union() {
                cylinder(d = 10, h = wall_h, $fn = 160);

                translate([0.9, -4.3, 0])
                  cube([2.2, 4.3, wall_h]);

                translate([-4.3, 0.9, 0])
                  cube([4.3, 2.2, wall_h]);
              }

              translate([0, 0, -0.1])
                cylinder(d = (10 - 2 * 0.4 * 5) - 0.8, h = wall_h + 2, $fn = 160);

              translate([-10, -(10 / 2 + 0.4 * 5) - 0.8 / 2, -0.1])
                cube([10, 10, 20]);

              translate([-(10 / 2 + 0.4 * 5) - 0.8 / 2, -10, -0.1])
                cube([10, 10, 20]);
            }

            // Top
            translate([0, 0, 1.2]) {
              difference() {
                cylinder(d = tab_d, h = wall_h, $fn = 160);

                translate([0, 0, -0.1])
                  cylinder(d = tab_d - 2 * 0.4 * 5, h = wall_h + 2, $fn = 160);

                translate([-10, -10 / 2 - 0.4 * 5, -0.1])
                  cube([10, 10, 20]);

                translate([-10 / 2 - 0.4 * 5, -10, -0.1])
                  cube([10, 10, 20]);
              }

              translate([0.9, -4.3, 0])
                cube([2, 4.3, wall_h]);

              translate([-4.3, 0.9, 0])
                cube([4.3, 2, wall_h]);
            }
          }
        }
      }
    }

    translate([board_x, board_y, 0]) {
      // USB and SD card cutout
      translate([-70 / 2 - 26.5, -5, case_t + 6.75]) {
        difference() {
          cube([25, 35, case_t + 1]);

          for(i = [0 : 1]) {
            translate([-1, i * (35 + 2) - 1, -3])
            rotate([45, 0, 0])
            translate([0, -8 / 2, -8 / 2])
              cube([27, 8, 8]);
          }
        }
      }

      // Digital input and output cutouts
      translate([70 / 2 + 1.5, -31.5, case_t + 6.75]) {
        difference() {
          cube([25, 65.5, case_t + 1]);

          for(i = [0 : 1]) {
            translate([-1, i * (65.5 + 2) - 1, -3])
            rotate([45, 0, 0])
            translate([0, -8 / 2, -8 / 2])
              cube([27, 8, 8]);
          }
        }
      }

      // Servo cutout
      translate([70 / 2 - 7.5, -6, -1]) {
        cylinder(d = 6, h = case_t + wall_h, $fn = 90);

        translate([0, -6 / 2, 0])
          cube([35, 6, case_t + wall_h]);
      }

      // Power LED viewport
      translate([-20, 32.35, -10])
        cylinder(d = 2.6, h = 50, $fn = 90);

      // Debugging buttons
      /*for(i = [0 : 1]) {
        translate([-5.55 - i * 0.15, 3.65 + i * 5.2, -10])
          cylinder(d = 3.2, h = 50, $fn = 90);
      }*/
    }

    // Bottom case mount holes
    for(i = [0 : 3]) {
      translate([case_standoff[i][0], case_standoff[i][1], -1])
      rotate([0, 0, case_standoff[i][2]]) {
        cylinder(d = 3.4, h = wall_h + 3, $fn = 90);

        cylinder(d = 5.8, h = 2.4 + 1, $fn = 90);

        translate([0, 0, 2.4 + 1])
          cylinder(d1 = 5.8, d2 = 3.4, h = 1.8, $fn = 90);
      }
    }

    // Outer fillets
    for(i = [0 : 1])
    for(j = [0 : 1]) {
      mirror([i, 0, 0])
      mirror([0, j, 0]) {
        translate([case_w / 2, case_l / 2, -0.1])
        difference() {
          translate([-10 / 2, -10 / 2, 0])
            cube([10, 10, case_t + wall_h + 1]);

          translate([-10 / 2, -10 / 2, -0.1])
            cylinder(d = 10, h = case_t + wall_h + 2, $fn = 160);
        }
      }
    }

    translate([0, 0, -0.1])
      roofus();
  }
}

// ----------------------------------------------------------------------------------
// Saddle parts

module top_saddle(zipties = false) {
  bearing_x = 23.5;
  bearing_y = 10.5;

  difference() {
    union() {
      // Main plate
      translate([-saddle_l / 2, -saddle_w / 2, 0])
        cube([saddle_l, saddle_w, saddle_t]);

      // Mount standoffs
      for(i = [-1 : 1])
      for(j = [-1 : 1]) {
        if(abs(i + j) != 1)
        translate([i * saddle_mount_l / 2,
                   j * saddle_mount_w / 2, 0]) {
          cylinder(d = standoff_d, h = saddle_t + 8.5, $fn = 160);

          // Fillets
          difference() {
            cylinder(d = standoff_d + 2, h = saddle_t + 1, $fn = 160);

            translate([0, 0, saddle_t + 1])
              torus(r1 = standoff_d + 2, r2 = 1);
          }
        }
      }

      // LM8UU bearing blocks
      difference() {
        union() {
          for(i = [0 : 1])
          for(j = [0 : 1]) {
            mirror([i, 0, 0])
            mirror([0, j, 0]) {
              difference() {
                translate([bearing_x, bearing_y, 0])
                  cube([27.5, 22, saddle_t + 8.5]);
              }
            }
          }

          // Bottom chamfers and reinforcement bars
          for(n = [0 : 1]) {
            mirror([0, n, 0])
            translate([-saddle_l / 2, bearing_y + 22 / 2, 0]) {
              for(i = [-1 : 2 : 1]) {
                translate([0, i * (22 / 2 - 0.5), saddle_t - 0.5]) {
                  rotate([45, 0, 0])
                  translate([0, -3 / 2, -3 / 2])
                    cube([saddle_l, 3, 3]);
                }

                translate([0, i * (21 / 2 - 0.5) - 0.4 * 5 / 2,
                           saddle_t - 0.5])
                  cube([saddle_l, 0.4 * 5, 4 + 0.5]);
              }
            }
          }
        }

        // Ziptie slots for endstop wires and servo wires
        for(i = [0 : 1])
        for(j = [0 : 1]) {
          mirror([i, 0, 0])
          mirror([0, j, 0])
            translate([12, 0, saddle_t + 3 * sqrt(2) / 2 - 1])
              cube([3, 40, 1.2]);
        }

        // Top chamfers
        for(i = [0 : 1])
        for(j = [0 : 1]) {
          mirror([i, 0, 0])
          mirror([0, j, 0]) {
            translate([bearing_x, bearing_y + 22 / 2, 8.5]) {
              for(i = [-1 : 2 : 1]) {
                translate([-10, i * (22 / 2 + 3), 5])
                rotate([45, 0, 0])
                  translate([0, -8 / 2, -8 / 2])
                    cube([50, 8, 8]);

                translate([-10, i * 1.5, 5])
                rotate([45, 0, 0])
                  translate([0, -8 / 2, -8 / 2])
                    cube([50, 8, 8]);
              }
            }
          }
        }
      }

      // Cross reinforcement
      for(i = [-1 : 1]) {
        translate([i * 24.5 - 1, -22 / 2, saddle_t])
          cube([0.4 * 5, 22, 4]);
      }

      // Ziptie slots for bearings
      if(zipties == true) {
        for(i = [0 : 1])
        for(j = [0 : 1]) {
          mirror([i, 0, 0])
          mirror([0, j, 0]) {
            translate([bearing_x, bearing_y + 22 / 2, 0]) {
              for(n = [0 : 1]) {
                mirror([0, n, 0])
                translate([8 - 3 / 2, 11, 0])
                difference() {
                  cube([3 + 2 * 0.4 * 5, 1.2 + 0.4 * 5, saddle_t + 3.6]);

                  translate([0.4 * 5, 0, 0])
                    cube([3, 1.2, 16]);

                  translate([0.4 * 5, 0, saddle_t])
                    cube([3, 5, 1.2]);
                }
              }
            }
          }
        }
      }
    }

    // Main plate cutouts
    for(n = [0 : 1]) {
      mirror([0, n, 0])
      translate([0, -saddle_mount_w / 2 - (15 + 3 * sqrt(2) / 2 - 2), -0.1]) {
        translate([-38 / 2, 0, 0])
          cube([38, 15, 10]);

        for(i = [-1 : 2 : 1])
          translate([i * 38 / 2, 0, 0])
          rotate([0, 0, 45])
            cube([15 * sqrt(2) / 2, 15 * sqrt(2) / 2, 10]);
      }
    }

    // Stress cutouts
    for(n = [0 : 1])
    for(m = [-1 : 1]) {
      mirror([n, 0, 0])
      translate([14 - 3 * abs(m), m * 21.5, 1.8]) {
        for(i = [0 : 1])
        for(j = [0 : 1]) {
          mirror([i, 0, 0])
          mirror([0, j, 0]) {
            translate([4, 4, 0])
              cylinder(d = 6.0, h = saddle_t + 1, $fn = 90);
          }
        }

        translate([-8 / 2, -14 / 2, 0])
          cube([8, 14, saddle_t + 1]);

        translate([-14 / 2, -8 / 2, 0])
          cube([14, 8, saddle_t + 1]);
      }
    }

    // Mount hole cutouts
    for(i = [-1 : 1])
    for(j = [-1 : 1])
      if(abs(i + j) != 1)
      translate([i * saddle_mount_l / 2,
                 j * saddle_mount_w / 2, -0.1]) {
        cylinder(d = 3.2, h = saddle_t + 8.5 + 1, $fn = 120);

        cylinder(d = 5.8, h = 3 + 0.1, $fn = 120);

        translate([0, 0, 3 + 0.1])
          cylinder(d1 = 5.8, d2 = 3.2, h = 1.6, $fn = 120);
    }

    // LM8UU bearing cutouts
    for(i = [0 : 1])
    for(j = [0 : 1]) {
      mirror([i, 0, 0])
      mirror([0, j, 0]) {
        translate([bearing_x, bearing_y + 22 / 2, 8.5]) {

          // Shaft clearance check
          translate([-10, 0, 0])
          rotate([0, 90, 0])
            cylinder(d = 8, h = 50, $fn = 60);

          // End clearance
          rotate([0, 90, 0])
            cylinder(d = 11, h = 30, $fn = 90);

          // Bearing seats
          translate([(27.5 - 23.5) / 2 - 0.4, 0, 0])
          rotate([0, 90, 0])
            cylinder(d = 15 + 0.1, h = 24, $fn = 60);

          // Top clearance
          translate([-10, -10 / 2, 0])
            cube([50, 10, 8]);

          translate([1.6, -14 / 2, 0])
            cube([24, 14, 8]);
        }
      }
    }

    // Cutout for endstop wires
    translate([35, 0, -0.1]) {
      translate([-4 / 2, -8 / 2, 0])
        cube([4, 8, saddle_t + 1]);

      translate([-2 / 2, -10 / 2, 0])
        cube([2, 10, saddle_t + 1]);

      for(i = [-1 : 2 : 1])
      for(j = [-1 : 2 : 1]) {
        translate([i * 1, j * 4, -0.1])
          cylinder(d = 2, h = saddle_t + 1, $fn = 120);
      }
    }

    // M2 hex nut seats for endstop
    for(i = [-1 : 2 : 1])
    for(j = [-1 : 2 : 1]) {
      translate([i * (42.5 + 1), j * 4.75, -0.1]) {
        cylinder(d = 2.2, h = saddle_t + 1, $fn = 90);

        cylinder(d = 4.1 / (sqrt(3) / 2), h = 1.8, $fn = 6);

        translate([0, 0, 1.8])
          cylinder(d1 = 4.1 / (sqrt(3) / 2), d2 = 2.2, h = 1.2, $fn = 6);
      }
    }

    // Corner fillets
    for(i = [0 : 1])
    for(j = [0 : 1]) {
      mirror([i, 0, 0])
      mirror([0, j, 0]) {
        translate([saddle_l / 2, saddle_w / 2, -0.1])
        difference() {
          translate([-10 / 2, -10 / 2, 0])
            cube([10, 10, saddle_t + 1]);

          translate([-10 / 2, -10 / 2, -0.1])
            cylinder(d = 10, h = saddle_t + 2, $fn = 160);
        }
      }
    }

    // Pen pal text
    mirror([1, 0, 0])
    rotate([0, 0, 90]) {
      translate([0, 6, -0.1])
      linear_extrude(height = 0.6 + 0.1)
        text("Pen", halign = "center", size = 16, font = "Marsha & Joshua");

      translate([-2, -28, -0.1])
      linear_extrude(height = 0.6 + 0.1)
        text("Pal", halign = "center", size = 16, font = "Marsha & Joshua");
    }
  }
}

module bottom_saddle(zipties = false) {
  bearing_x = 11;
  bearing_y = 24;

  difference() {
    union() {
      // Main plate
      translate([-saddle_l / 2, -saddle_w / 2, 0])
        cube([saddle_l, saddle_w, saddle_t]);

      // Mount standoffs
      for(i = [-1 : 1])
      for(j = [-1 : 1]) {
        if(abs(i + j) != 1)
        translate([i * saddle_mount_l / 2,
                   j * saddle_mount_w / 2, 0]) {
          cylinder(d = standoff_d, h = saddle_t + 8.5, $fn = 160);

          // Fillets
          difference() {
            cylinder(d = standoff_d + 2, h = saddle_t + 1, $fn = 220);

            translate([0, 0, saddle_t + 1])
              torus(r1 = standoff_d + 2, r2 = 1);
          }
        }
      }

      // LM8UU bearing blocks
      rotate([0, 0, 90])
      difference() {
        union() {
          for(i = [0 : 1])
          for(j = [0 : 1]) {
            mirror([i, 0, 0])
            mirror([0, j, 0]) {
              difference() {
                translate([bearing_x, bearing_y, 0])
                  cube([27.5, 22, saddle_t + 8.5]);
              }
            }
          }

          // Bottom chamfers and reinforcement bars
          for(n = [0 : 1]) {
            mirror([0, n, 0])
            translate([-saddle_w / 2, bearing_y + 22 / 2, 0]) {
              for(i = [-1 : 2 : 1]) {
                translate([0, i * (22 / 2 - 0.5), saddle_t - 0.5]) {
                  rotate([45, 0, 0])
                  translate([0, -3 / 2, -3 / 2])
                    cube([saddle_w, 3, 3]);
                }

                translate([0, i * (21 / 2 - 0.5) - 0.4 * 5 / 2,
                           saddle_t - 0.5])
                  cube([saddle_w, 0.4 * 5, 4 + 0.5]);
              }
            }
          }
        }

        // Top chamfers
        for(i = [0 : 1])
        for(j = [0 : 1]) {
          mirror([i, 0, 0])
          mirror([0, j, 0]) {
            translate([bearing_x, bearing_y + 22 / 2, 8.5]) {
              for(i = [-1 : 2 : 1]) {
                translate([-10, i * (22 / 2 + 3), 5])
                rotate([45, 0, 0])
                  translate([0, -8 / 2, -8 / 2])
                    cube([50, 8, 8]);

                translate([-10, i * 1.5, 5])
                rotate([45, 0, 0])
                  translate([0, -8 / 2, -8 / 2])
                    cube([50, 8, 8]);
              }
            }
          }
        }
      }

      // CoreXY bearing seats
      for(i = [-1 : 2 : 1])
      for(j = [-1 : 2 : 1]) {
        translate([i * 15, j * 15, 0])
          cylinder(d = 15, h = saddle_t + 8, $fn = 160);
      }

      // Cross reinforcement
      for(i = [0 : 1]) {
        rotate([0, 0, i * 90 + 45])
        translate([-0.4 * 5 / 2, -30 / 2, saddle_t])
          cube([0.4 * 5, 30, 4]);
      }

      for(i = [0 : 1])
      for(j = [-1 : 2 : 1]) {
        mirror([i, 0, 0])
        translate([15, j * 15 - 0.4 * 5 / 2, saddle_t])
          cube([10, 0.4 * 5, 6.85]);
      }

      // Ziptie slots for bearings
      if(zipties == true) {
        rotate([0, 0, 90])
        for(i = [0 : 1])
        for(j = [0 : 1]) {
          mirror([i, 0, 0])
          mirror([0, j, 0]) {
            translate([bearing_x, bearing_y + 22 / 2, 0]) {
              for(n = [0 : 1]) {
                mirror([0, n, 0])
                translate([24 / 2 - 3 / 2, 11, 0])
                difference() {
                  cube([3 + 2 * 0.4 * 5, 1.2 + 0.4 * 5, saddle_t + 3.6]);

                  translate([0.4 * 5, 0, 0])
                    cube([3, 1.2, 16]);

                  translate([0.4 * 5, 0, saddle_t])
                    cube([3, 5, 1.2]);
                }
              }
            }
          }
        }
      }
    }

    // Main plate cutouts
    for(n = [0 : 1]) {
      mirror([0, n, 0])
      translate([0, -saddle_mount_w / 2 - 15, -0.1]) {
        translate([-38 / 2, 0, 0])
          cube([38, 15, 10]);

        for(i = [-1 : 2 : 1])
          translate([i * 38 / 2, 0, 0])
          rotate([0, 0, 45])
            cube([15 * sqrt(2) / 2, 15 * sqrt(2) / 2, 10]);
      }
    }

    // Optional, anti-resonance
    for(i = [0 : 3]) {
      rotate([0, 0, i * 90])
      translate([12.5 + (i % 2) * 2, 0, -0.1]) {
        cylinder(d = 9 + (i % 2) * 1, h = saddle_t + 1, $fn = 120);

        translate([0, -(9 + (i % 2) * 1) / 2, 0])
          cube([8 / 2 + (i % 2) * 2, 9 + (i % 2) * 1, saddle_t + 1]);

        translate([8 / 2 + (i % 2) * 2, 0, 0])
          cylinder(d = 9 + (i % 2) * 1, h = saddle_t + 1, $fn = 120);
      }
    }

    // Mount hole cutouts
    for(i = [-1 : 1])
    for(j = [-1 : 1]) {
      if(abs(i + j) != 1)
      translate([i * saddle_mount_l / 2,
                 j * saddle_mount_w / 2, -0.1])
      rotate([0, 0, -45 * (i * j)]) {
        cylinder(d = 3.2, h = saddle_t + 8.5 + 1, $fn = 90);

        cylinder(d = 5.8 / (sqrt(3) / 2), h = 3 + 0.1, $fn = 6);

        translate([0, 0, 3 + 0.1])
          cylinder(d1 = 5.8 / (sqrt(3) / 2), d2 = 3.2, h = 1.2, $fn = 6);
      }
    }

    // CoreXY bearing mount holes
    for(i = [-1 : 2 : 1])
    for(j = [-1 : 2 : 1]) {
      translate([i * 15, j * 15, -0.1]) {
        cylinder(d = 3.2, h = saddle_t + 8.5 + 1, $fn = 90);

        cylinder(d = 5.8 / (sqrt(3) / 2), h = 2.4 + 0.1, $fn = 6);

        translate([0, 0, 2.4 + 0.1])
          cylinder(d1 = 5.8 / (sqrt(3) / 2), d2 = 3.2, h = 1.2, $fn = 6);
      }
    }

    // LM8UU bearing cutouts
    rotate([0, 0, 90])
    for(i = [0 : 1])
    for(j = [0 : 1]) {
      mirror([i, 0, 0])
      mirror([0, j, 0]) {
        translate([bearing_x, bearing_y + 22 / 2, 8.5]) {

          // Shaft clearance check
          translate([-10, 0, 0])
          rotate([0, 90, 0])
            cylinder(d = 8, h = 50, $fn = 60);

          // End clearance
          rotate([0, 90, 0])
            cylinder(d = 11, h = 30, $fn = 90);

          // Bearing seats
          translate([(27.5 - 23.5) / 2 - 0.4, 0, 0])
          rotate([0, 90, 0])
            cylinder(d = 15 + 0.1, h = 24, $fn = 60);

          // Top clearance
          translate([-10, -10 / 2, 0])
            cube([50, 10, 8]);

          translate([1.6, -14 / 2, 0])
            cube([24, 14, 8]);
        }
      }
    }

    // Corner fillets
    for(i = [0 : 1])
    for(j = [0 : 1]) {
      mirror([i, 0, 0])
      mirror([0, j, 0]) {
        translate([saddle_l / 2, saddle_w / 2, -0.1])
        difference() {
          translate([-10 / 2, -10 / 2, 0])
            cube([10, 10, saddle_t + 1]);

          translate([-10 / 2, -10 / 2, -0.1])
            cylinder(d = 10, h = saddle_t + 2, $fn = 160);
        }
      }
    }
  }

  // Endstop pushers
  for(i = [0 : 1]) {
    mirror([0, i, 0])
    translate([-6, saddle_w / 2 - 10, 0])
    difference() {
      cube([6, 10, saddle_t + 4]);

      translate([-2, -1, 8 + 0.1])
      rotate([45, 0, 0])
      translate([0, -8 / 2, -8 / 2])
        cube([10, 8, 8]);
    }
  }
}

// It's also possible to use 10mm tall M3 brass or aluminum standoffs
module saddle_standoffs() {
  for(i = [-1 : 1])
  for(j = [-1 : 1]) {
    if(abs(i + j) != 1)
    translate([i * saddle_mount_l / 2,
               j * saddle_mount_w / 2, 0]) {
      difference() {
        cylinder(d = standoff_d, h = 9.6, $fn = 120);

        translate([0, 0, -1])
          cylinder(d = 3.2, h = 9.6 + 2, $fn = 90);
      }
    }
  }
}

module idler_pulley() {
  difference() {
    union() {
      cylinder(d = 18, h = 1.2, $fn = 260);

      cylinder(d = 14, h = 9.2, $fn = 220);

      translate([0, 0, 9.2 - 1.2])
        cylinder(d = 18, h = 1.2, $fn = 260);
    }

    translate([0, 0, -0.1])
      cylinder(d = 10 - 1.2, h = 12, $fn = 90);

    translate([0, 0, -0.1])
      cylinder(d = 10, h = 4 + 0.1, $fn = 160);
  }
}

// ----------------------------------------------------------------------------------
// Y axis parts

module y_rear_block() {
  difference() {
    // Main block
    translate([-10 / 2, -62 / 2, -9 - 0.15])
      cube([10, 62, 28]);

    for(i = [0 : 1]) {
      // Rod holes
      mirror([0, i, 0])
      translate([0, 10.5 + 22 / 2, 0]) {
        translate([-10 / 2 - 1, 0, -8.5 + (17.3 + 0.05)])
        rotate([0, 90, 0])
          cylinder(d = 8 + 0.15, h = 12, $fn = 100);

        // M3 holes and hex nut slots for rod clamps
        translate([0, 0, -12])
          cylinder(d = 3.2, h = 22, $fn = 90);

        translate([0, 0, -4]) {
          cylinder(d = 5.9 / (sqrt(3) / 2), h = 2.4, $fn = 6);

          translate([-6, -5.9 / 2, 0])
            cube([6, 5.9, 2.4]);
        }
      }
    }

    // Middle hole and hex nut seat for idler bearing bolt
    translate([0, 0, -12])
      cylinder(d = 3.2, h = 30, $fn = 90);

    translate([0, 0, 10]) {
      cylinder(d = 5.9 / (sqrt(3) / 2), h = 2.4, $fn = 6);

      translate([-6, -5.9 / 2, 0])
        cube([6, 5.9, 2.4]);
    }

    // Idler bearing clearance
    translate([0, 0, -1.2]) {
      for(i = [-1 : 2 : 1])
      for(j = [-1 : 2 : 1]) {
        translate([-6, i * (20 / 2 - 3 / 2), j * (11 / 2 - 3 / 2)])
        rotate([0, 90, 0])
          cylinder(d = 3, h = 12, $fn = 90);
      }

      translate([-6, -20 / 2 + 3 / 2, -11 / 2])
        cube([12, 20 - 3, 11]);

      translate([-6, -20 / 2, -11 / 2 + 3 / 2])
        cube([12, 20, 11 - 3]);
    }

    // Wire mount ziptie holes, optional
    for(i = [-1 : 2 : 1])
    for(j = [-1 : 2 : 1]) {
      translate([-4 / 2, i * 11, 15]) {
        translate([0, j * 6 / 2 - 1.2 / 2, 0])
          cube([4, 1.2, 10]);

        translate([0, -6 / 2 - 1.2 / 2 + 0.1, 0])
          cube([4, 6 + 1.2 - 0.2, 1.2]);
      }
    }

    // Outer fillets
    translate([-6, 0, 4.85])
    rotate([0, 90, 0]) {
      for(i = [0 : 1])
      for(j = [0 : 1]) {
        mirror([i, 0, 0])
        mirror([0, j, 0]) {
          translate([28 / 2, 62 / 2, -0.1])
          difference() {
            translate([-10 / 2, -10 / 2, 0])
              cube([10, 10, 12]);

            translate([-10 / 2, -10 / 2, -0.1])
              cylinder(d = 10, h = 12 + 2, $fn = 160);
          }
        }
      }
    }
  }
}

module y_front_block() {
  // Width of the GT2 belt slot
  belt_w = 1.4;
  servo_h = 2;

  translate([-0.5, 0, 0])
  difference() {
    union() {
      // Main block
      translate([-10 / 2, -76 / 2, -6.5])
        cube([10, 76, 28]);

      // Servo mount
      translate([-10 / 2, -36 / 2, 9.5 + servo_h])
        cube([3, 36, 26]);
    }

    for(i = [0 : 1]) {
      // Rod holes
      mirror([0, i, 0])
      translate([0, 10.5 + 22 / 2, 0]) {
        translate([-10 / 2 - 1, 0, -8.5 + (17.3 + 0.05)])
        rotate([0, 90, 0])
          cylinder(d = 8 + 0.15, h = 12, $fn = 100);

        // M3 holes and hex nut slots for rod clamps
        translate([0, 0, -12])
          cylinder(d = 3.2, h = 22, $fn = 90);

        translate([0, 0, -2]) {
          cylinder(d = 5.9 / (sqrt(3) / 2), h = 2.4, $fn = 6);

          translate([-6, -5.9 / 2, 0])
            cube([6, 5.9, 2.4]);
        }
      }
    }

    // Mount points for pen flexure
    for(i = [-1 : 2 : 1])
    for(j = [-1 : 2 : 1]) {
      translate([-6, i * 32, -6.5 + 28 / 2 + j * 7.8])
      rotate([0, 90, 0]) {
        cylinder(d = 3.2, h = 12, $fn = 90);

        rotate([0, 0, -i * 15 + ((j - 1) / 2) * 30]) {
          cylinder(d = 5.8 / (sqrt(3) / 2), h = 1 + 2.4, $fn = 6);

          translate([0, 0, 1 + 2.4])
            cylinder(d1 = 5.8 / (sqrt(3) / 2), d2 = 3.2, h = 1.2, $fn = 6);
        }
      }
    }

    // Cutouts for GT2 belt
    for(i = [-1 : 2 : 1]) {
      translate([-6, i * 7.25 - belt_w / 2, -4])
        cube([12, belt_w, 10]);
    }

    difference() {
      translate([-6, -7.25 - belt_w / 2, 4])
        cube([12, 2 * 7.25 + belt_w, 6]);

      rotate([0, 90, 0])
      for(j = [0 : 1]) {
        mirror([0, j, 0]) {
          translate([-10, 7.25 + belt_w / 2, -6])
          difference() {
            translate([-5 / 2, -5 / 2, 0])
              cube([5, 5, 12]);

            translate([5 / 2, -5 / 2, -0.1])
              cylinder(d = 5, h = 12 + 2, $fn = 160);
          }
        }
      }
    }

    // Belt mount fillets
    rotate([0, 90, 0])
    for(j = [0 : 1]) {
      mirror([0, j, 0]) {
        translate([-4, 7.25 - belt_w / 2, -6])
        difference() {
          translate([-4 / 2, -4 / 2, 0])
            cube([4, 3, 12]);

          translate([4 / 2, -4 / 2, -0.1])
            cylinder(d = 4, h = 12 + 2, $fn = 160);
        }
      }
    }

    // Servo mount cutouts - MG90D is 12.0mm wide and 22.6mm long
    translate([-10 / 2 - 1, -22.8 / 2, 19.5 + servo_h]) {
      cube([12, 22.8, 12.4]);

      for(i = [-1 : 2 : 1])
      translate([0, i * 27.5 / 2 + 22.8 / 2, 12.2 / 2])
      rotate([0, 90, 0])
        cylinder(d = 2, h = 6, $fn = 60);
    }

    // Servo mount top fillets
    translate([-6, 0, 22.5 + servo_h])
    rotate([0, 90, 0]) {
      for(j = [0 : 1]) {
        mirror([0, j, 0])
        translate([-26 / 2, 36 / 2, -1])
        difference() {
          translate([-10 / 2, -10 / 2, 0])
            cube([10, 10, 6]);

          translate([10 / 2, -10 / 2, -0.1])
            cylinder(d = 10, h = 12 + 2, $fn = 160);
        }
      }
    }

    // Outer body fillets
    translate([-6, 0, 7.5])
    rotate([0, 90, 0]) {
      for(i = [0 : 1])
      for(j = [0 : 1]) {
        mirror([i, 0, 0])
        mirror([0, j, 0]) {
          translate([28 / 2, 76 / 2, -0.1])
          difference() {
            translate([-10 / 2, -10 / 2, 0])
              cube([10, 10, 12]);

            translate([-10 / 2, -10 / 2, -0.1])
              cylinder(d = 10, h = 12 + 2, $fn = 160);
          }
        }
      }
    }
  }

  // GT2 tooth profile
  for(j = [-1 : 2 : 1]) {
    translate([-1, j * (7.25 - belt_w / 2 + 0.4 / 2), 0])
    difference() {
      translate([-4.5, -0.75 / 2, -6.5])
        cube([10, 0.75, 8]);

      for(i = [0 : 5]) {
        translate([-4.5 + i * 2.0, j * 0.375, -6.5 - 1]) {
          // Main cutout
          cylinder(r = 0.555 + 0.02, h = 8 + 2, $fn = 70);

          // Edge fillets
          for(k = [-1 : 2 : 1]) {
            translate([k * (0.555 + 0.15), -j * 0.3 / 2, 0])
            difference() {
              translate([-k * 0.3 / 2 - 0.3 / 2, j * 0.3 / 2 - 0.3 / 2, 0])
                cube([0.3, 0.3, 8 + 2]);

              translate([0, 0, -1])
                cylinder(r = 0.15, h = 8 + 4, $fn = 40);
            }
          }
        }
      }
    }
  }
}

module pen_flexure() {
  z_flexure_w = 50;
  z_flexure_h = 60;
  z_inner_w = 26;

  difference() {
    union() {
      // Inner drive bar
      translate([-z_flexure_w / 2 - 28 / 2, -12 / 2, -12 / 2])
        cube([z_flexure_w + 28, 12, 12]);

      // Main flexure elements
      for(i = [0 : 1])
      for(j = [0 : 1]) {
        mirror([i, 0, 0])
        mirror([0, 0, j]) {
          translate([0, 0, z_inner_w]) {
            // Outer flexure elements
            translate([-z_flexure_w / 2, -12 / 2, -z_inner_w])
              cube([0.4 * 2, 12, z_flexure_h]);

            // Inner flexure elements
            translate([-(z_flexure_w - 22) / 2, -12 / 2, 0])
              cube([0.4 * 2, 12, z_flexure_h - z_inner_w]);
          }
        }
      }

      difference() {
        union() {
          // Top bar
          translate([-z_flexure_w / 2 - (4 + 10), -12 / 2 - 8, -36 / 2])
            cube([10, 12 + 8, 36]);

          // Bottom bar
          translate([z_flexure_w / 2 + 4, -12 / 2 - 8, -36 / 2])
            cube([10, 12 + 8, 36]);
        }

        // Mount holes and hex nut seats for pen
        for(m = [-1 : 2 : 1])
        for(n = [-1 : 2 : 1]) {
          translate([m * (z_flexure_w / 2 + 18 / 2), 8, n * 12.5])
          rotate([90, 0, 0])
          rotate([0, 0, 30]) {
            cylinder(d = 3.2, h = 24, $fn = 60);

            translate([0, 0, 22 - 2.4])
              cylinder(d = 5.8 / (sqrt(3) / 2), h = 3, $fn = 6);
          }
        }
      }

      for(i = [0 : 1])
      mirror([0, 0, i]) {
        // Outer bars
        translate([-z_flexure_w / 2, -12 / 2, z_flexure_h])
          cube([z_flexure_w, 12, 6]);

        // Inner mount bars
        difference() {
          translate([-(z_flexure_w - 22) / 2, -12 / 2 - 6, z_inner_w])
            cube([z_flexure_w - 22, 12 + 6, 12]);

          // Mount holes and countersinks
          for(m = [-1 : 2 : 1]) {
            translate([m * 7.8, 8, z_inner_w + 12 / 2])
            rotate([90, 0, 0]) {
              cylinder(d = 3.2, h = 24, $fn = 60);

              cylinder(d = 5.8, h = 4, $fn = 90);

              translate([0, 0, 4])
                cylinder(d1 = 5.8, d2 = 3.2, h = 1.8, $fn = 90);
            }
          }

          // Outer fillets
          translate([0, -6, 32])
          rotate([90, 0, 0]) {
            for(i = [0 : 1]) {
              mirror([i, 0, 0]) {
                translate([28 / 2, 12 / 2, -0.1])
                difference() {
                  translate([-10 / 2, -10 / 2, 0])
                    cube([10, 10, 12]);

                  translate([-10 / 2, -10 / 2, -0.1])
                    cylinder(d = 10, h = 12 + 2, $fn = 160);
                }
              }
            }
          }
        }
      }
    }

    // Pen groove
    translate([-z_flexure_w - 1, 12 / 2 + 2.5, 0])
    rotate([45, 0, 0])
      translate([0, -8 / 2, -8 / 2])
        cube([2 * z_flexure_w + 2, 8, 8]);
  }
}

// The top and bottom clamp pieces for pens
module pen_clamp() {
  difference() {
    union() {
      // Top bar
      translate([-10 / 2, -20 + 0.8, -36 / 2])
        cube([10, 20 - 0.8, 36]);
    }

    // Mount holes and hex nut seats for pen
    for(n = [-1 : 2 : 1]) {
      translate([0, 4, n * 12.5])
      rotate([90, 0, 0]) {
        cylinder(d = 3.2, h = 26, $fn = 60);

        translate([0, 0, 22 - 2.4])
          cylinder(d = 5.8, h = 5, $fn = 90);

        translate([0, 0, (22 - 2.4) - 1.8])
          cylinder(d1 = 3.2, d2 = 5.8, h = 1.8, $fn = 90);
      }
    }

    translate([0, -20 + 5.6 - 2.4, 0]) {
      rotate([90, 0, 0])
      translate([0, 0, -8]) {
        cylinder(d = 3.2, h = 14, $fn = 60);

        translate([0, 0, 5.6])
          cylinder(d = 5.8 / (sqrt(3) / 2), h = 2.4, $fn = 6);
      }
      translate([-25, 0, -5.8 / 2])
        cube([25, 2.4, 5.8]);
    }

    // Pen groove
    translate([-10, -4, 0]) {
      rotate([0, 90, 0])
        cylinder(d = 16, h = 20, $fn = 220);

      translate([0, 0, -16 / 2])
        cube([20, 10, 16]);
    }
  }
}

// ----------------------------------------------------------------------------------
// Assembly

module assembly(x_offset = 0, y_offset = 0) {
  x_length = 350;
  y_length = 450;

  belt_loop_d = 14.6;

  // Right side foot
  color("grey")
  translate([0, x_length / 2, 7.5 - 0.35])
  rotate([90, 0, 0])
  rotate([0, 0, -90])
    x_axis_block(controller = true);

  // Left side foot
  color("grey")
  translate([0, -x_length / 2, 7.5 - 0.35])
  rotate([-90, 0, 0])
  rotate([0, 0, 90])
    x_axis_block(controller = false);

  // Stepper motor models
  color("lightgrey")
  translate([0.05, x_length / 2 + 25, 26.5])
    rotate([0, 180, 0])
    translate([-121.68, -105, -17.15])
      import("NEMA_17_stepper.stl");

  color("lightgrey")
  translate([0.05, -x_length / 2 - 25, 26.5])
    rotate([0, 180, 0])
    translate([-121.68, -105, -17.15])
      import("NEMA_17_stepper.stl");

  // X axis limit switches
  for(i = [0 : 1]) {
    color("lightgrey")
    mirror([0, i, 0])
    translate([0, -x_length / 2 + 4.5, -14.8])
      //rotate([0, 180, 0])
      rotate([0, 0, 90])
        translate([-125, -104, 0])
          import("Limit_switch.stl");
  }

  // CNC driver board and case
  translate([-47.5 - 0.05, x_length / 2 + 33, 80 / 2 - 28 + 0.1])
  rotate([0, 0, -90])
  rotate([90, 0, 0]) {
    color("grey")
      driver_case_bottom();

    translate([board_x, board_y, 0])
    translate([0, 0, 7.2 + 0.05])
      driver_PCB();

    color("grey")
    translate([0, 0, 27 + 0.1])
      driver_case_top();
  }

  // Bottom 8mm linear rods
  color("lightgrey")
  for(i = [0 : 1]) {
    mirror([i, 0, 0])
    rotate([0, 0, 90])
    translate([0, 24 + 22 / 2, 8.5 - (17.3 + 0.05)]) {
      translate([-x_length / 2 - 2 / 2, 0, 0])
      rotate([0, 90, 0])
        cylinder(d = 8, h = x_length + 2, $fn = 100);
    }
  }

  // Threaded rod
  color("darkgrey")
  translate([0, -x_length / 2 - 12 / 2, -27.8])
  rotate([-90, 0, 0])
    cylinder(d = 8, h = x_length + 12, $fn = 100);

  // X axis belt section - clearance check
  color("orange") {
    // Main x belt lines
    for(i = [-1 : 2 : 1]) {
      translate([i * belt_loop_d / 2 - 1 / 2, -(x_length + 50) / 2, -4 + 0.6])
        cube([1, (x_length / 2 - belt_loop_d + 25) + x_offset, 6]);

      translate([i * belt_loop_d / 2 - 1 / 2, x_offset + belt_loop_d, -4 + 0.6])
        cube([1, (x_length / 2 - belt_loop_d + 25) - x_offset, 6]);
    }

    // End loops
    for(i = [0 : 1]) {
      mirror([0, i, 0])
      translate([0, -(x_length + 50) / 2, -4 + 0.6])
      difference() {
        cylinder(d = belt_loop_d + 1, h = 6, $fn = 120);

        translate([0, 0, -1])
          cylinder(d = belt_loop_d - 1, h = 8, $fn = 100);

        translate([-(belt_loop_d - 1) / 2, 0, -1])
          cube([belt_loop_d - 1, belt_loop_d, 8]);
      }
    }

    // Middle loops
    translate([0, x_offset, 0])
    for(i = [0 : 1])
    for(j = [0 : 1]) {
      mirror([i, 0, 0])
      mirror([0, j, 0])
      translate([-belt_loop_d, belt_loop_d, -4 + 0.6])
      difference() {
        cylinder(d = belt_loop_d + 1, h = 6, $fn = 120);

        translate([0, 0, -1])
          cylinder(d = belt_loop_d - 1, h = 8, $fn = 160);

        translate([-(belt_loop_d - 1) / 2, 0, -1])
          cube([belt_loop_d - 1, belt_loop_d, 8]);

        translate([-belt_loop_d, -(belt_loop_d - 1) / 2, -1])
          cube([belt_loop_d, belt_loop_d - 1, 8]);

      }
    }
  }

  // The saddle and Y axis assembly
  translate([0, x_offset, 0]) {
    color("grey")
    translate([0, 0, 0]) {
      translate([0, 0, 17.3 + 0.05])
      rotate([0, 180, 0])
        top_saddle();

      translate([0, 0, -17.3 - 0.05])
      rotate([0, 0, 0])
        bottom_saddle();

      // These can also just be metal standoffs
      translate([0, 0, -4.75 - 0.05])
        saddle_standoffs();
    }

    // LM8UU bearings, bottom
    color("silver")
    for(i = [-1 : 2 : 1])
    for(j = [-1 : 2 : 1]) {
      translate([i * 35, j * 24.6 + 12, -8.85])
      rotate([90, 0, 0])
        cylinder(d = 15, h = 24, $fn = 100);
    }

    // LM8UU bearings, top
    color("silver")
    for(i = [-1 : 2 : 1])
    for(j = [-1 : 2 : 1]) {
      translate([i * 37.1 - 12, j * 21.5, 8.85])
      rotate([0, 90, 0])
        cylinder(d = 15, h = 24, $fn = 100);
    }

    // Saddle limit switches
    for(i = [0 : 1]) {
      color("lightgrey")
      mirror([i, 0, 0])
      translate([-100 / 2 + 4.5, 0, 13.2])
      rotate([0, 180, 0])
        translate([-125, -104, 0])
          import("Limit_switch.stl");
    }

    // Idler pulleys
    for(i = [-1 : 2 : 1])
    for(j = [-1 : 2 : 1]) {
      color("coral")
      translate([i * 15, j * 15, -6.8 / 2 - 1.6])
        idler_pulley();
    }

    translate([y_offset, 0, 0]) {
      // Top 8mm rods
      color("lightgrey")
      for(i = [0 : 1]) {
        mirror([0, i, 0])
        translate([0, 10.5 + 22 / 2, -8.5 + (17.3 + 0.05)]) {
          translate([-y_length / 2 - 2 / 2, 0, 0])
          rotate([0, 90, 0])
            cylinder(d = 8, h = y_length + 2, $fn = 100);
        }
      }

      // Y axis belt section
      color("orange") {
        // Main y belt lines
        for(i = [-1 : 2 : 1]) {
          // Loop end
          translate([-y_length / 2 + 4, i * belt_loop_d / 2 - 1 / 2, -4 + 0.6])
            cube([(y_length / 2 - (belt_loop_d + 4)) - y_offset, 1, 6]);

          translate([belt_loop_d - y_offset, i * belt_loop_d / 2 - 1 / 2, -4 + 0.6])
            cube([(y_length / 2 - (belt_loop_d + 4) + 7) + y_offset, 1, 6]);

        }

        // Back loop
        translate([-y_length / 2 + 4, 0, -4 + 0.6])
        difference() {
          cylinder(d = belt_loop_d + 1, h = 6, $fn = 120);

          translate([0, 0, -1])
            cylinder(d = belt_loop_d - 1, h = 8, $fn = 100);

          translate([0, -(belt_loop_d - 1) / 2, -1])
            cube([16, belt_loop_d - 1, 8]);
        }
      }

      // Back piece of Y axis
      color("grey")
      translate([-y_length / 2 + 10 / 2, 0, 0])
        y_rear_block();

      color("grey")
      translate([y_length / 2 - 4.5, 0, 0])
        y_front_block();

      color("lightblue")
      translate([y_length / 2 - 16, 0, 27.65])
      rotate([180, 0, 0])
      rotate([0, 0, -90])
        sg90_servo(angle = -135);

      // Pen section
      color("grey")
      translate([y_length / 2 + 12 + 0.1, 0, 7.5]) {
        rotate([0, 0, -90])
        rotate([0, 90, 0])
          pen_flexure();

        for(i = [-1 : 2 : 1])
        translate([6 + 0.1, 0, i * 34])
          rotate([0, 0, 90])
          rotate([0, 90, 0])
            pen_clamp();
      }
    }
  }
}

// Generate the part in the suggested print orientation
module print_part(part_num = 0) {
  // The two X axis blocks, where the motors go
  if(part_num == 0)
    translate([0, 0, 10])
    rotate([180, 0, 0])
      x_axis_block(controller = true);

  if(part_num == 1)
    translate([0, 0, 10])
    rotate([180, 0, 0])
      x_axis_block(controller = false);

  // The two saddle parts
  if(part_num == 2)
    top_saddle();

  if(part_num == 3)
    bottom_saddle();

  // The saddle standoffs and idler pulleys
  if(part_num == 4)
    saddle_standoffs();

  if(part_num == 5)
    translate([0, 0, 9.2])
    rotate([0, 180, 0])
      idler_pulley();

  // The two Y axis blocks
  if(part_num == 6)
    translate([0, 0, 5])
    rotate([0, 90, 0])
      y_rear_block();

  if(part_num == 7)
    translate([0, 0, 5.5])
    rotate([0, -90, 0])
      y_front_block();

  // The pen drive mechanism
  if(part_num == 8)
    translate([0, 0, 6])
    rotate([-90, 0, 0])
      pen_flexure();

  if(part_num == 9)
    translate([0, 10, 5])
    rotate([0, 90, 0])
      pen_clamp();

  // The CNC controller box
  if(part_num == 10)
    rotate([0, 180, 0])
      driver_case_top();

  if(part_num == 11)
    driver_case_bottom();
}

// Maximum x is +/-125.0mm (9 3/4" total travel),
// Maximum y is +/-162.5mm (12 3/4" total travel)
assembly(x_offset = 0, y_offset = 0);

//print_part(10);

// EOF

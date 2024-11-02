`define BASIC 1
`define SPLIT_INOUTS
/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

/* verilator lint_off DECLFILENAME */
/* verilator lint_off PINCONNECTEMPTY */

`default_nettype none

// for tinytapeout we target ice40, but then replace SB_IO cells
// by a custom implementation
`define ICE40 1
`define SIM_SB_IO 1

module tt_um_warp (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // https://tinytapeout.com/specs/pinouts/

  // register reset
  reg rst_n_q;
  always @(posedge clk) begin
    rst_n_q <= rst_n;
  end

  wire __unused_out_done;
  wire __unused_out_clock;

  M_main main(

    .in_ui(ui_in),
    .out_uo(uo_out),

    .inout_uio_i(uio_in),
    .inout_uio_o(uio_out),
    .inout_uio_oe(uio_oe),

    .in_run(1'b1),
    .reset(~rst_n_q),
    .clock(clk),

    .out_done (__unused_out_done),
    .out_clock(__unused_out_clock)
  );

  // prevents warning
  wire _unused = &{ena,1'b0};

  //              vvvvv inputs when in reset to allow PMOD external takeover
  // assign uio_oe = rst_n ? {1'b1,1'b1,main_uio_oe[3],main_uio_oe[2],1'b1,main_uio_oe[1],main_uio_oe[0],1'b1} : 8'h00;

endmodule

module M_vga_M_main_demo_vga (
out_vga_hs,
out_vga_vs,
out_active,
out_vblank,
out_vga_x,
out_vga_y,
reset,
out_clock,
clock
);
output  [0:0] out_vga_hs;
output  [0:0] out_vga_vs;
output  [0:0] out_active;
output  [0:0] out_vblank;
output  [11:0] out_vga_x;
output  [10:0] out_vga_y;
input reset;
output out_clock;
input clock;
assign out_clock = clock;

reg signed [10:0] _d_xcount;
reg signed [10:0] _q_xcount;
reg signed [9:0] _d_ycount;
reg signed [9:0] _q_ycount;
reg  [0:0] _d_active_h;
reg  [0:0] _q_active_h;
reg  [0:0] _d_active_v;
reg  [0:0] _q_active_v;
reg  [0:0] _d_vga_hs;
reg  [0:0] _q_vga_hs;
reg  [0:0] _d_vga_vs;
reg  [0:0] _q_vga_vs;
reg  [0:0] _d_active;
reg  [0:0] _q_active;
reg  [0:0] _d_vblank;
reg  [0:0] _q_vblank;
reg  [11:0] _d_vga_x;
reg  [11:0] _q_vga_x;
reg  [10:0] _d_vga_y;
reg  [10:0] _q_vga_y;
assign out_vga_hs = _q_vga_hs;
assign out_vga_vs = _q_vga_vs;
assign out_active = _q_active;
assign out_vblank = _q_vblank;
assign out_vga_x = _q_vga_x;
assign out_vga_y = _q_vga_y;



`ifdef FORMAL
initial begin
assume(reset);
end
`endif
always @* begin
_d_xcount = _q_xcount;
_d_ycount = _q_ycount;
_d_active_h = _q_active_h;
_d_active_v = _q_active_v;
_d_vga_hs = _q_vga_hs;
_d_vga_vs = _q_vga_vs;
_d_active = _q_active;
_d_vblank = _q_vblank;
_d_vga_x = _q_vga_x;
_d_vga_y = _q_vga_y;
// _always_pre
// __block_1
_d_active_h = _q_xcount==0 ? 1:_q_xcount==640 ? 0:_q_active_h;

_d_active_v = _q_ycount==0 ? 1:_q_ycount==480 ? 0:_q_active_v;

_d_active = _d_active_h&&_d_active_v;

_d_vga_x = _d_active_h ? _q_xcount:0;

_d_vga_y = _d_active_v ? _q_ycount:0;

_d_vga_hs = _q_xcount==-144 ? 0:_q_xcount==-49 ? 1:_q_vga_hs;

_d_vga_vs = _q_ycount==-35 ? 0:_q_ycount==-34 ? 1:_q_vga_vs;

_d_vblank = _q_ycount[9+:1];

if (_q_xcount==640) begin
// __block_2
// __block_4
_d_xcount = $signed(-159);

if (_q_ycount==480) begin
// __block_5
// __block_7
_d_ycount = $signed(-44);

// __block_8
end else begin
// __block_6
// __block_9
_d_ycount = _q_ycount+1;

// __block_10
end
// 'after'
// __block_11
// __block_12
end else begin
// __block_3
// __block_13
_d_xcount = _q_xcount+1;

// __block_14
end
// 'after'
// __block_15
// __block_16
// _always_post
// pipeline stage triggers
end

always @(posedge clock) begin
_q_xcount <= (reset) ? 0 : _d_xcount;
_q_ycount <= (reset) ? 0 : _d_ycount;
_q_active_h <= (reset) ? 0 : _d_active_h;
_q_active_v <= (reset) ? 0 : _d_active_v;
_q_vga_hs <= (reset) ? 0 : _d_vga_hs;
_q_vga_vs <= (reset) ? 0 : _d_vga_vs;
_q_active <= _d_active;
_q_vblank <= _d_vblank;
_q_vga_x <= _d_vga_x;
_q_vga_y <= _d_vga_y;
end

endmodule

// ==== defines ====
`undef  _c___block_1_next_sample
`define _c___block_1_next_sample (1'((_q_clock_count[0+:9]==0)))
`undef  _c___block_1_sum
`define _c___block_1_sum (9'((_w_tri_wave+_w_squ_wave)))
`undef  _c___block_1_next_inc
`define _c___block_1_next_inc (1'(`_c___block_1_next_sample&&(_q_rythm_count[0+:8]==8'd0)))
`undef  _c___block_1_next_note
`define _c___block_1_next_note (1'(_q_rythm_count[8+:5]==5'd20))
`undef  _c___block_1_smpl
`define _c___block_1_smpl (7'($unsigned($signed(_t_audio8)+$signed(8'd64))))
// ===============

module M_music_M_main_demo_zic (
in_go,
out_audio8,
out_audio1,
reset,
out_clock,
clock
);
input  [0:0] in_go;
output signed [7:0] out_audio8;
output  [0:0] out_audio1;
input reset;
output out_clock;
input clock;
wire __unused_go = &{1'b0,in_go};
assign out_clock = clock;
reg signed [7:0] _t_audio8;
reg  [0:0] _t_audio1;
wire signed [7:0] _w_tri_wave;
wire signed [7:0] _w_squ_wave;

reg  [6:0] _d_idx;
reg  [6:0] _q_idx;
reg  [8:0] _d_clock_count;
reg  [8:0] _q_clock_count;
reg  [12:0] _d_rythm_count;
reg  [12:0] _q_rythm_count;
reg  [3:0] _d_drum_inc;
reg  [3:0] _q_drum_inc;
reg  [11:0] _d_tpos;
reg  [11:0] _q_tpos;
reg  [12:0] _d_qpos;
reg  [12:0] _q_qpos;
reg  [5:0] _d_squ_env;
reg  [5:0] _q_squ_env;
assign out_audio8 = _t_audio8;
assign out_audio1 = _t_audio1;


assign _w_tri_wave = {_q_tpos[11+:1],_q_tpos[4+:7]^{7{_q_tpos[10+:1]^_q_tpos[11+:1]}}};
assign _w_squ_wave = _q_qpos[12+:1] ? _q_squ_env[3+:3]:-_q_squ_env[3+:3];

`ifdef FORMAL
initial begin
assume(reset);
end
`endif
always @* begin
_d_idx = _q_idx;
_d_clock_count = _q_clock_count;
_d_rythm_count = _q_rythm_count;
_d_drum_inc = _q_drum_inc;
_d_tpos = _q_tpos;
_d_qpos = _q_qpos;
_d_squ_env = _q_squ_env;
// _always_pre
// __block_1


_t_audio8 = ~in_go ? 8'b0:($signed(`_c___block_1_sum)>>>1);

_d_tpos = `_c___block_1_next_sample ? (_q_tpos+_c_bass[_q_idx[0+:5]]+_q_drum_inc):_q_tpos;

_d_qpos = `_c___block_1_next_sample ? (_q_qpos+_c_keys[_q_idx]):_q_qpos;



_d_idx = `_c___block_1_next_note ? (_q_idx==7'd95 ? 7'd32:_q_idx+1):_q_idx;

_d_drum_inc = `_c___block_1_next_note ? {16{(|_c_drum[_d_idx])}}:(`_c___block_1_next_inc ? ((_q_drum_inc!=0) ? _q_drum_inc-1:0):_q_drum_inc);

_d_squ_env = `_c___block_1_next_note ? {6{|_c_keys[_d_idx]}}:(`_c___block_1_next_inc ? ((_q_squ_env!=0) ? _q_squ_env-1:0):_q_squ_env);

_d_rythm_count = `_c___block_1_next_note||~in_go ? 0:(`_c___block_1_next_sample ? _q_rythm_count+1:_q_rythm_count);


_t_audio1 = _q_clock_count[0+:7]<`_c___block_1_smpl ? 1'b1:1'b0;

_d_clock_count = in_go ? (_q_clock_count+1):0;

// __block_2
// _always_post
// pipeline stage triggers
end
// ==== wires ====
wire  [3:0] _c_bass[31:0];
assign _c_bass[0] = 8;
assign _c_bass[1] = 7;
assign _c_bass[2] = 6;
assign _c_bass[3] = 5;
assign _c_bass[4] = 6;
assign _c_bass[5] = 8;
assign _c_bass[6] = 9;
assign _c_bass[7] = 6;
assign _c_bass[8] = 5;
assign _c_bass[9] = 8;
assign _c_bass[10] = 7;
assign _c_bass[11] = 6;
assign _c_bass[12] = 5;
assign _c_bass[13] = 6;
assign _c_bass[14] = 8;
assign _c_bass[15] = 9;
assign _c_bass[16] = 8;
assign _c_bass[17] = 7;
assign _c_bass[18] = 6;
assign _c_bass[19] = 5;
assign _c_bass[20] = 6;
assign _c_bass[21] = 8;
assign _c_bass[22] = 9;
assign _c_bass[23] = 6;
assign _c_bass[24] = 5;
assign _c_bass[25] = 8;
assign _c_bass[26] = 7;
assign _c_bass[27] = 6;
assign _c_bass[28] = 5;
assign _c_bass[29] = 6;
assign _c_bass[30] = 8;
assign _c_bass[31] = 9;
wire  [1:0] _c_drum[95:0];
assign _c_drum[0] = 0;
assign _c_drum[1] = 0;
assign _c_drum[2] = 0;
assign _c_drum[3] = 0;
assign _c_drum[4] = 0;
assign _c_drum[5] = 0;
assign _c_drum[6] = 0;
assign _c_drum[7] = 0;
assign _c_drum[8] = 0;
assign _c_drum[9] = 0;
assign _c_drum[10] = 0;
assign _c_drum[11] = 0;
assign _c_drum[12] = 2;
assign _c_drum[13] = 1;
assign _c_drum[14] = 0;
assign _c_drum[15] = 0;
assign _c_drum[16] = 0;
assign _c_drum[17] = 0;
assign _c_drum[18] = 0;
assign _c_drum[19] = 0;
assign _c_drum[20] = 2;
assign _c_drum[21] = 1;
assign _c_drum[22] = 0;
assign _c_drum[23] = 0;
assign _c_drum[24] = 0;
assign _c_drum[25] = 0;
assign _c_drum[26] = 0;
assign _c_drum[27] = 0;
assign _c_drum[28] = 2;
assign _c_drum[29] = 1;
assign _c_drum[30] = 0;
assign _c_drum[31] = 0;
assign _c_drum[32] = 2;
assign _c_drum[33] = 1;
assign _c_drum[34] = 0;
assign _c_drum[35] = 0;
assign _c_drum[36] = 2;
assign _c_drum[37] = 1;
assign _c_drum[38] = 0;
assign _c_drum[39] = 0;
assign _c_drum[40] = 2;
assign _c_drum[41] = 1;
assign _c_drum[42] = 0;
assign _c_drum[43] = 0;
assign _c_drum[44] = 2;
assign _c_drum[45] = 1;
assign _c_drum[46] = 0;
assign _c_drum[47] = 0;
assign _c_drum[48] = 2;
assign _c_drum[49] = 1;
assign _c_drum[50] = 0;
assign _c_drum[51] = 0;
assign _c_drum[52] = 2;
assign _c_drum[53] = 1;
assign _c_drum[54] = 0;
assign _c_drum[55] = 0;
assign _c_drum[56] = 2;
assign _c_drum[57] = 1;
assign _c_drum[58] = 0;
assign _c_drum[59] = 0;
assign _c_drum[60] = 2;
assign _c_drum[61] = 1;
assign _c_drum[62] = 0;
assign _c_drum[63] = 0;
assign _c_drum[64] = 2;
assign _c_drum[65] = 1;
assign _c_drum[66] = 0;
assign _c_drum[67] = 0;
assign _c_drum[68] = 2;
assign _c_drum[69] = 1;
assign _c_drum[70] = 0;
assign _c_drum[71] = 0;
assign _c_drum[72] = 2;
assign _c_drum[73] = 1;
assign _c_drum[74] = 0;
assign _c_drum[75] = 0;
assign _c_drum[76] = 2;
assign _c_drum[77] = 1;
assign _c_drum[78] = 0;
assign _c_drum[79] = 0;
assign _c_drum[80] = 2;
assign _c_drum[81] = 1;
assign _c_drum[82] = 0;
assign _c_drum[83] = 0;
assign _c_drum[84] = 2;
assign _c_drum[85] = 1;
assign _c_drum[86] = 0;
assign _c_drum[87] = 0;
assign _c_drum[88] = 2;
assign _c_drum[89] = 1;
assign _c_drum[90] = 0;
assign _c_drum[91] = 0;
assign _c_drum[92] = 2;
assign _c_drum[93] = 1;
assign _c_drum[94] = 0;
assign _c_drum[95] = 0;
wire  [6:0] _c_keys[95:0];
assign _c_keys[0] = 0;
assign _c_keys[1] = 0;
assign _c_keys[2] = 0;
assign _c_keys[3] = 0;
assign _c_keys[4] = 0;
assign _c_keys[5] = 0;
assign _c_keys[6] = 0;
assign _c_keys[7] = 0;
assign _c_keys[8] = 0;
assign _c_keys[9] = 0;
assign _c_keys[10] = 0;
assign _c_keys[11] = 0;
assign _c_keys[12] = 0;
assign _c_keys[13] = 0;
assign _c_keys[14] = 0;
assign _c_keys[15] = 0;
assign _c_keys[16] = 0;
assign _c_keys[17] = 0;
assign _c_keys[18] = 0;
assign _c_keys[19] = 0;
assign _c_keys[20] = 0;
assign _c_keys[21] = 0;
assign _c_keys[22] = 0;
assign _c_keys[23] = 0;
assign _c_keys[24] = 0;
assign _c_keys[25] = 0;
assign _c_keys[26] = 0;
assign _c_keys[27] = 0;
assign _c_keys[28] = 0;
assign _c_keys[29] = 0;
assign _c_keys[30] = 0;
assign _c_keys[31] = 0;
assign _c_keys[32] = 16;
assign _c_keys[33] = 33;
assign _c_keys[34] = 33;
assign _c_keys[35] = 16;
assign _c_keys[36] = 17;
assign _c_keys[37] = 35;
assign _c_keys[38] = 33;
assign _c_keys[39] = 16;
assign _c_keys[40] = 33;
assign _c_keys[41] = 16;
assign _c_keys[42] = 0;
assign _c_keys[43] = 33;
assign _c_keys[44] = 35;
assign _c_keys[45] = 0;
assign _c_keys[46] = 11;
assign _c_keys[47] = 22;
assign _c_keys[48] = 22;
assign _c_keys[49] = 44;
assign _c_keys[50] = 44;
assign _c_keys[51] = 22;
assign _c_keys[52] = 46;
assign _c_keys[53] = 23;
assign _c_keys[54] = 22;
assign _c_keys[55] = 44;
assign _c_keys[56] = 44;
assign _c_keys[57] = 22;
assign _c_keys[58] = 44;
assign _c_keys[59] = 22;
assign _c_keys[60] = 46;
assign _c_keys[61] = 23;
assign _c_keys[62] = 11;
assign _c_keys[63] = 22;
assign _c_keys[64] = 33;
assign _c_keys[65] = 66;
assign _c_keys[66] = 66;
assign _c_keys[67] = 33;
assign _c_keys[68] = 70;
assign _c_keys[69] = 35;
assign _c_keys[70] = 33;
assign _c_keys[71] = 66;
assign _c_keys[72] = 66;
assign _c_keys[73] = 33;
assign _c_keys[74] = 0;
assign _c_keys[75] = 66;
assign _c_keys[76] = 70;
assign _c_keys[77] = 0;
assign _c_keys[78] = 44;
assign _c_keys[79] = 22;
assign _c_keys[80] = 16;
assign _c_keys[81] = 33;
assign _c_keys[82] = 22;
assign _c_keys[83] = 11;
assign _c_keys[84] = 12;
assign _c_keys[85] = 23;
assign _c_keys[86] = 11;
assign _c_keys[87] = 22;
assign _c_keys[88] = 22;
assign _c_keys[89] = 11;
assign _c_keys[90] = 22;
assign _c_keys[91] = 11;
assign _c_keys[92] = 23;
assign _c_keys[93] = 12;
assign _c_keys[94] = 11;
assign _c_keys[95] = 22;
// ===============

always @(posedge clock) begin
_q_idx <= (reset) ? 0 : _d_idx;
_q_clock_count <= (reset) ? 0 : _d_clock_count;
_q_rythm_count <= (reset) ? 0 : _d_rythm_count;
_q_drum_inc <= _d_drum_inc;
_q_tpos <= (reset) ? 0 : _d_tpos;
_q_qpos <= (reset) ? 0 : _d_qpos;
_q_squ_env <= (reset) ? 0 : _d_squ_env;
end

endmodule

// ==== defines ====
`undef  _c___stage___block_61_cx0
`define _c___stage___block_61_cx0 (5'(_t___stage___block_61_cx_6<27 ? _t___stage___block_61_cx_6[0+:5]:26))
`undef  _c___stage___block_61_cx1
`define _c___stage___block_61_cx1 (5'(`_c___stage___block_61_cx0+1))
`undef  _c___stage___block_61_d1
`define _c___stage___block_61_d1 (12'($signed({1'b0,_c_inv_l[`_c___stage___block_61_cx0]})+((($signed({1'b0,_c_inv_l[`_c___stage___block_61_cx1]})-$signed({1'b0,_c_inv_l[`_c___stage___block_61_cx0]}))*$signed({7'b0,_q___pip_58_1_3___stage___block_3_cx&5'd31}))>>>5)))
`undef  _c___stage___block_61_d2
`define _c___stage___block_61_d2 (11'($signed(`_c___stage___block_61_d1)>>1))
`undef  _c___stage___block_61_d3
`define _c___stage___block_61_d3 (11'(`_c___stage___block_61_d2>>1))
`undef  _c___stage___block_61_mk
`define _c___stage___block_61_mk (1'(|_q_effect))
`undef  _c___stage___block_61_ma1
`define _c___stage___block_61_ma1 (6'((_q_effect==1 ? 1:0)|(_q_effect==2 ? 48:0)|(_q_effect==3 ? 16:0)))
`undef  _c___stage___block_61_ma2
`define _c___stage___block_61_ma2 (6'((_q_effect==1 ? 1:0)|(_q_effect==2 ? 32:0)|(_q_effect==3 ? 8:0)))
`undef  _c___stage___block_61_rseg1
`define _c___stage___block_61_rseg1 (8'(~(|_q_effect) ? _q_speed>>2:0))
`undef  _c___stage___block_61_rseg2
`define _c___stage___block_61_rseg2 (8'(~(|_q_effect) ? _q_speed>>2:0))
`undef  _c___stage___block_61_rseg3
`define _c___stage___block_61_rseg3 (8'(~(|_q_effect) ? _q_speed>>1:0))
`undef  _c___stage___block_61_cmode
`define _c___stage___block_61_cmode (1'(_q_effect[1+:1]))
`undef  _c___stage___block_61_mmode
`define _c___stage___block_61_mmode (1'(_q_effect[1+:1]))
`undef  _c___block_68_sh3
`define _c___block_68_sh3 (2'({`_c___stage___block_61_cmode,~`_c___stage___block_61_cmode}))
`undef  _c___block_68_dfs_12
`define _c___block_68_dfs_12 (8'(_t___block_68_df_12+(_t___stage___block_61_ma12[0+:1] ? _t___block_68_a_12:0)+(_t___stage___block_61_ma12[3+:1] ? {_t___block_68_a_12[0+:5],3'b0}:0)+(_t___stage___block_61_ma12[4+:1] ? {_t___block_68_a_12[0+:4],4'b0}:0)+(_t___stage___block_61_ma12[5+:1] ? {_t___block_68_a_12[0+:3],5'b0}:0)))
`undef  _c___block_68_dfs_3
`define _c___block_68_dfs_3 (8'(_t___block_68_df_3+(_t___stage___block_61_ma3[0+:1] ? _t___block_68_a_3:0)+(_t___stage___block_61_ma3[2+:1] ? {_t___block_68_a_3[0+:6],2'b0}:0)+(_t___stage___block_61_ma3[4+:1] ? {_t___block_68_a_3[0+:4],4'b0}:0)))
`undef  _c___block_68_c_12
`define _c___block_68_c_12 (6'((_t___block_68_dfa_12[2+:6]<((_q_th[2+:6])|6'b100))||~`_c___stage___block_61_cmode ? _t___block_68_dfa_12[_t___stage___block_61_sh12+:6]:6'd0))
`undef  _c___block_68_c_3
`define _c___block_68_c_3 (6'((_t___block_68_dfa_3[2+:6]<((_q_th[2+:6])|6'b100))||~`_c___stage___block_61_cmode ? _t___block_68_dfa_3[`_c___block_68_sh3+:6]:6'd0))
`undef  _c___block_87_atten_l
`define _c___block_87_atten_l (2'(_q___pip_58_1_3___stage___block_3_cx[9+:1]|_q___pip_58_1_3___stage___block_3_cx[10+:1] ? 2'b11:_q___pip_58_1_3___stage___block_3_cx[7+:2]))
`undef  _c___block_87_atten_h
`define _c___block_87_atten_h (3'(`_c___block_87_atten_l+3'b1))
`undef  _c___stage___block_88_bval6
`define _c___stage___block_88_bval6 (6'({_t___stage___block_88_q6[0+:1],_t___stage___block_88_p6[0+:1],_t___stage___block_88_q6[1+:1],_t___stage___block_88_p6[1+:1],_t___stage___block_88_q6[2+:1],_t___stage___block_88_p6[2+:1]}))
`undef  _c___stage___block_88_bval4
`define _c___stage___block_88_bval4 (4'({_t___stage___block_88_q4[0+:1],_t___stage___block_88_p4[0+:1],_t___stage___block_88_q4[1+:1],_t___stage___block_88_p4[1+:1]}))
`undef  _c___stage___block_88_c1a
`define _c___stage___block_88_c1a (6'(({2'b0,_q___pip_58_1_4___block_68_frag}*_q___pip_58_1_4___block_87_atten_l)>>2))
`undef  _c___stage___block_88_c1b
`define _c___stage___block_88_c1b (6'(({2'b0,_q___pip_58_1_4___block_68_frag}*_q___pip_58_1_4___block_87_atten_h)>>2))
`undef  _c___stage___block_88_c_l
`define _c___stage___block_88_c_l (2'(_t___stage___block_88_c[4+:2]))
`undef  _c___stage___block_88_c_h
`define _c___stage___block_88_c_h (2'(`_c___stage___block_88_c_l==2'b11 ? 2'b11:`_c___stage___block_88_c_l+1))
`undef  _c___stage___block_88_tunnel
`define _c___stage___block_88_tunnel (2'((_t___stage___block_88_c[0+:4]>`_c___stage___block_88_bval4) ? `_c___stage___block_88_c_h:`_c___stage___block_88_c_l))
`undef  _c___stage___block_88_lx
`define _c___stage___block_88_lx (5'({5{_t___stage___block_88_p_logo[0+:1]|_t___stage___block_88_p_logo[3+:1]}}^(_w_vga_vga_x[0+:5])))
`undef  _c___stage___block_88_ly
`define _c___stage___block_88_ly (5'(_w_vga_vga_y[0+:5]))
`undef  _c___stage___block_88_wedge
`define _c___stage___block_88_wedge (1'((`_c___stage___block_88_lx<`_c___stage___block_88_ly)^(_t___stage___block_88_p_logo[2+:1]|_t___stage___block_88_p_logo[3+:1])))
`undef  _c___stage___block_88_b_logo
`define _c___stage___block_88_b_logo (1'((|_t___stage___block_88_p_logo)&&(`_c___stage___block_88_wedge||(&_t___stage___block_88_p_logo))&&(_q_effect==2'd2)&&_q_go&&(_w_vga_vga_y>127)&&(_w_vga_vga_y<256)&&(_w_vga_vga_x[0+:5]<_q_th[1+:5]||_q_th[6+:1]||_q_th[7+:1]||_q_th[8+:1])))
`undef  _c___stage___block_88_fade
`define _c___stage___block_88_fade (1'(_q_go&&_q_frame[8+:1]&&_q_frame[7+:1]&&_q_frame[6+:1]&&(_q_frame[0+:6]>`_c___stage___block_88_bval6)))
`undef  _c___stage___block_88_final
`define _c___stage___block_88_final (2'(`_c___stage___block_88_tunnel|{`_c___stage___block_88_b_logo,1'b0}|{2{`_c___stage___block_88_fade}}))
`undef  _c___block_90_frame_tick
`define _c___block_90_frame_tick (1'((_q_prev_vs&~_w_vga_vga_vs)))
`undef  _c___block_90_next_effect
`define _c___block_90_next_effect (1'(&_q_frame[0+:9]))
// ===============

module M_vga_demo_M_main_demo (
out_video_r,
out_video_g,
out_video_b,
out_video_hs,
out_video_vs,
out_audio8,
out_audio1,
reset,
out_clock,
clock
);
output  [1:0] out_video_r;
output  [1:0] out_video_g;
output  [1:0] out_video_b;
output  [0:0] out_video_hs;
output  [0:0] out_video_vs;
output  [7:0] out_audio8;
output  [0:0] out_audio1;
input reset;
output out_clock;
input clock;
assign out_clock = clock;
wire  [0:0] _w_vga_vga_hs;
wire  [0:0] _w_vga_vga_vs;
wire  [0:0] _w_vga_active;
wire  [0:0] _w_vga_vblank;
wire  [11:0] _w_vga_vga_x;
wire  [10:0] _w_vga_vga_y;
wire __unused__vga = &{_w_vga_vga_hs,_w_vga_vga_vs,_w_vga_active,_w_vga_vblank,_w_vga_vga_x,_w_vga_vga_y,1'b0};
wire signed [7:0] _w_zic_audio8;
wire  [0:0] _w_zic_audio1;
wire __unused__zic = &{_w_zic_audio8,_w_zic_audio1,1'b0};
reg signed [5:0] _t___stage___block_3_trix;
reg signed [5:0] _t___stage___block_3_triy;
reg signed [10:0] _t___stage___block_3_x;
reg signed [10:0] _t___stage___block_3_y;
reg signed [10:0] _t___stage___block_3_cx;
reg signed [10:0] _t___stage___block_3_cy;
reg signed [7:0] _t___stage___block_3_a;
reg signed [10:0] _t___stage___block_17_cxtt;
reg signed [10:0] _t___stage___block_17_cytt;
reg signed [7:0] _t___stage___block_17_att;
reg signed [10:0] _t___block_24_cxt;
reg signed [10:0] _t___block_24_cyt;
reg signed [7:0] _t___block_24_at;
reg signed [10:0] _t___stage___block_39_cxtt;
reg signed [10:0] _t___stage___block_39_cytt;
reg signed [7:0] _t___stage___block_39_att;
reg signed [10:0] _t___block_46_cxt;
reg signed [10:0] _t___block_46_cyt;
reg signed [7:0] _t___block_46_at;
reg  [5:0] _t___stage___block_61_cx_6;
reg  [5:0] _t___stage___block_61_ma3;
reg  [5:0] _t___stage___block_61_ma12;
reg  [7:0] _t___stage___block_61_rseg12;
reg  [10:0] _t___stage___block_61_d12;
reg  [0:0] _t___stage___block_61_sh12;
reg  [7:0] _t___block_68_df_12;
reg  [7:0] _t___block_68_df_3;
reg  [7:0] _t___block_68_a_12;
reg  [7:0] _t___block_68_a_3;
reg  [7:0] _t___block_68_dfa_12;
reg  [7:0] _t___block_68_dfa_3;
reg  [5:0] _t___block_68_frag;
reg  [5:0] _t___block_68_frag12;
reg  [5:0] _t___stage___block_88_p6;
reg  [2:0] _t___stage___block_88_q6;
reg  [3:0] _t___stage___block_88_p4;
reg  [1:0] _t___stage___block_88_q4;
reg  [5:0] _t___stage___block_88_c;
reg  [79:0] _t___stage___block_88_r_logo;
reg  [3:0] _t___stage___block_88_p_logo;
reg  [5:0] _t___pip_58_1_3___block_68_frag;
reg  [2:0] _t___pip_58_1_3___block_87_atten_h;
reg  [1:0] _t___pip_58_1_3___block_87_atten_l;
reg signed [7:0] _t___pip_58_1_0___stage___block_3_a;
reg signed [10:0] _t___pip_58_1_0___stage___block_3_cx;
reg signed [10:0] _t___pip_58_1_0___stage___block_3_cy;
reg  [1:0] _t_video_r;
reg  [1:0] _t_video_g;
reg  [1:0] _t_video_b;
reg  [0:0] _t_video_hs;
reg  [0:0] _t_video_vs;

reg  [15:0] _d_frame;
reg  [15:0] _q_frame;
reg  [0:0] _d_go;
reg  [0:0] _q_go;
reg  [15:0] _d_speed;
reg  [15:0] _q_speed;
reg  [0:0] _d_prev_vs;
reg  [0:0] _q_prev_vs;
reg  [7:0] _d_prev_b;
reg  [7:0] _q_prev_b;
reg  [7:0] _d_prev_r;
reg  [7:0] _q_prev_r;
reg  [8:0] _d_th;
reg  [8:0] _q_th;
reg  [1:0] _d_effect;
reg  [1:0] _q_effect;
reg  [0:0] _d_rot_en;
reg  [0:0] _q_rot_en;
reg  [5:0] _d___pip_58_1_4___block_68_frag;
reg  [5:0] _q___pip_58_1_4___block_68_frag;
reg  [2:0] _d___pip_58_1_4___block_87_atten_h;
reg  [2:0] _q___pip_58_1_4___block_87_atten_h;
reg  [1:0] _d___pip_58_1_4___block_87_atten_l;
reg  [1:0] _q___pip_58_1_4___block_87_atten_l;
reg signed [7:0] _d___pip_58_1_1___stage___block_3_a;
reg signed [7:0] _q___pip_58_1_1___stage___block_3_a;
reg signed [7:0] _d___pip_58_1_2___stage___block_3_a;
reg signed [7:0] _q___pip_58_1_2___stage___block_3_a;
reg signed [7:0] _d___pip_58_1_3___stage___block_3_a;
reg signed [7:0] _q___pip_58_1_3___stage___block_3_a;
reg signed [10:0] _d___pip_58_1_1___stage___block_3_cx;
reg signed [10:0] _q___pip_58_1_1___stage___block_3_cx;
reg signed [10:0] _d___pip_58_1_2___stage___block_3_cx;
reg signed [10:0] _q___pip_58_1_2___stage___block_3_cx;
reg signed [10:0] _d___pip_58_1_3___stage___block_3_cx;
reg signed [10:0] _q___pip_58_1_3___stage___block_3_cx;
reg signed [10:0] _d___pip_58_1_4___stage___block_3_cx;
reg signed [10:0] _q___pip_58_1_4___stage___block_3_cx;
reg signed [10:0] _d___pip_58_1_1___stage___block_3_cy;
reg signed [10:0] _q___pip_58_1_1___stage___block_3_cy;
reg signed [10:0] _d___pip_58_1_2___stage___block_3_cy;
reg signed [10:0] _q___pip_58_1_2___stage___block_3_cy;
assign out_video_r = _t_video_r;
assign out_video_g = _t_video_g;
assign out_video_b = _t_video_b;
assign out_video_hs = _t_video_hs;
assign out_video_vs = _t_video_vs;
assign out_audio8 = _w_zic_audio8;
assign out_audio1 = _w_zic_audio1;
M_vga_M_main_demo_vga vga (
.out_vga_hs(_w_vga_vga_hs),
.out_vga_vs(_w_vga_vga_vs),
.out_active(_w_vga_active),
.out_vblank(_w_vga_vblank),
.out_vga_x(_w_vga_vga_x),
.out_vga_y(_w_vga_vga_y),
.reset(reset),
.clock(clock),.out_clock()
);
M_music_M_main_demo_zic zic (
.in_go(_d_go),
.out_audio8(_w_zic_audio8),
.out_audio1(_w_zic_audio1),
.reset(reset),
.clock(clock),.out_clock()
);



`ifdef FORMAL
initial begin
assume(reset);
end
`endif
always @* begin
_d_frame = _q_frame;
_d_go = _q_go;
_d_speed = _q_speed;
_d_prev_vs = _q_prev_vs;
_d_prev_b = _q_prev_b;
_d_prev_r = _q_prev_r;
_d_th = _q_th;
_d_effect = _q_effect;
_d_rot_en = _q_rot_en;
_d___pip_58_1_4___block_68_frag = _q___pip_58_1_4___block_68_frag;
_d___pip_58_1_4___block_87_atten_h = _q___pip_58_1_4___block_87_atten_h;
_d___pip_58_1_4___block_87_atten_l = _q___pip_58_1_4___block_87_atten_l;
_d___pip_58_1_1___stage___block_3_a = _q___pip_58_1_1___stage___block_3_a;
_d___pip_58_1_2___stage___block_3_a = _q___pip_58_1_2___stage___block_3_a;
_d___pip_58_1_3___stage___block_3_a = _q___pip_58_1_3___stage___block_3_a;
_d___pip_58_1_1___stage___block_3_cx = _q___pip_58_1_1___stage___block_3_cx;
_d___pip_58_1_2___stage___block_3_cx = _q___pip_58_1_2___stage___block_3_cx;
_d___pip_58_1_3___stage___block_3_cx = _q___pip_58_1_3___stage___block_3_cx;
_d___pip_58_1_4___stage___block_3_cx = _q___pip_58_1_4___stage___block_3_cx;
_d___pip_58_1_1___stage___block_3_cy = _q___pip_58_1_1___stage___block_3_cy;
_d___pip_58_1_2___stage___block_3_cy = _q___pip_58_1_2___stage___block_3_cy;
_t___stage___block_3_cx = 0;
_t___stage___block_3_cy = 0;
_t___stage___block_3_a = 0;
_t___block_68_frag = 0;
// _always_pre
// __block_1
// __block_2
// --> pipeline __pip_58_1 starts here
// pipeline
// -------- stage 0
// __stage___block_3
_t___stage___block_3_trix = {_q_frame[7+:1],_q_frame[1+:5]^{5{_q_frame[6+:1]^_q_frame[7+:1]}}}&{6{_q_rot_en}};

_t___stage___block_3_triy = {_q_frame[6+:1],_q_frame[0+:5]^{5{_q_frame[5+:1]^_q_frame[6+:1]}}}&{6{_q_rot_en}};

_t___stage___block_3_x = $signed(_w_vga_vga_x)-320+{{2{_t___stage___block_3_trix[5+:1]}},_t___stage___block_3_trix,3'b0};

_t___stage___block_3_y = $signed(_w_vga_vga_y)-240+{{2{_t___stage___block_3_triy[5+:1]}},_t___stage___block_3_triy,3'b0};

  case ({_t___stage___block_3_y[10+:1],_t___stage___block_3_x[10+:1]})
  2'b11: begin
// __block_5_case
// __block_6
_t___stage___block_3_cx = -_t___stage___block_3_x;

_t___stage___block_3_cy = -_t___stage___block_3_y;

_t___stage___block_3_a = 128;

// __block_7
  end
  2'b01: begin
// __block_8_case
// __block_9
_t___stage___block_3_cx = _t___stage___block_3_y;

_t___stage___block_3_cy = -_t___stage___block_3_x;

_t___stage___block_3_a = 192;

// __block_10
  end
  2'b00: begin
// __block_11_case
// __block_12
_t___stage___block_3_cx = _t___stage___block_3_y;

_t___stage___block_3_cy = -_t___stage___block_3_x;

_t___stage___block_3_a = 192;

// __block_13
  end
  2'b10: begin
// __block_14_case
// __block_15
_t___stage___block_3_cx = _t___stage___block_3_x;

_t___stage___block_3_cy = _t___stage___block_3_y;

_t___stage___block_3_a = 0;

// __block_16
// end of pipeline stage
  end
endcase
// __block_4
// --- trickling
_t___pip_58_1_0___stage___block_3_cy = _t___stage___block_3_cy;
_t___pip_58_1_0___stage___block_3_cx = _t___stage___block_3_cx;
_t___pip_58_1_0___stage___block_3_a = _t___stage___block_3_a;
// -------- stage 1
// __stage___block_17
if (_q___pip_58_1_1___stage___block_3_cy[10+:1]) begin
// __block_18
// __block_20
_t___stage___block_17_cxtt = _q___pip_58_1_1___stage___block_3_cx-(_q___pip_58_1_1___stage___block_3_cy>>>0);

_t___stage___block_17_cytt = _q___pip_58_1_1___stage___block_3_cy+(_q___pip_58_1_1___stage___block_3_cx>>>0);

_t___stage___block_17_att = _q___pip_58_1_1___stage___block_3_a+32;

// __block_21
end else begin
// __block_19
// __block_22
_t___stage___block_17_cxtt = _q___pip_58_1_1___stage___block_3_cx+(_q___pip_58_1_1___stage___block_3_cy>>>0);

_t___stage___block_17_cytt = _q___pip_58_1_1___stage___block_3_cy-(_q___pip_58_1_1___stage___block_3_cx>>>0);

_t___stage___block_17_att = _q___pip_58_1_1___stage___block_3_a-32;

// __block_23
end
// 'after'
// __block_24
if (_t___stage___block_17_cytt[10+:1]) begin
// __block_25
// __block_27
_t___block_24_cxt = _t___stage___block_17_cxtt-(_t___stage___block_17_cytt>>>1);

_t___block_24_cyt = _t___stage___block_17_cytt+(_t___stage___block_17_cxtt>>>1);

_t___block_24_at = _t___stage___block_17_att+18;

// __block_28
end else begin
// __block_26
// __block_29
_t___block_24_cxt = _t___stage___block_17_cxtt+(_t___stage___block_17_cytt>>>1);

_t___block_24_cyt = _t___stage___block_17_cytt-(_t___stage___block_17_cxtt>>>1);

_t___block_24_at = _t___stage___block_17_att-18;

// __block_30
end
// 'after'
// __block_31
if (_t___block_24_cyt[10+:1]) begin
// __block_32
// __block_34
_d___pip_58_1_1___stage___block_3_cx = _t___block_24_cxt-(_t___block_24_cyt>>>2);

_d___pip_58_1_1___stage___block_3_cy = _t___block_24_cyt+(_t___block_24_cxt>>>2);

_d___pip_58_1_1___stage___block_3_a = _t___block_24_at+9;

// __block_35
end else begin
// __block_33
// __block_36
_d___pip_58_1_1___stage___block_3_cx = _t___block_24_cxt+(_t___block_24_cyt>>>2);

_d___pip_58_1_1___stage___block_3_cy = _t___block_24_cyt-(_t___block_24_cxt>>>2);

_d___pip_58_1_1___stage___block_3_a = _t___block_24_at-9;

// __block_37
end
// 'after'
// __block_38
// end of pipeline stage
// --- trickling
// -------- stage 2
// __stage___block_39
if (_q___pip_58_1_2___stage___block_3_cy[10+:1]) begin
// __block_40
// __block_42
_t___stage___block_39_cxtt = _q___pip_58_1_2___stage___block_3_cx-(_q___pip_58_1_2___stage___block_3_cy>>>3);

_t___stage___block_39_cytt = _q___pip_58_1_2___stage___block_3_cy+(_q___pip_58_1_2___stage___block_3_cx>>>3);

_t___stage___block_39_att = _q___pip_58_1_2___stage___block_3_a+5;

// __block_43
end else begin
// __block_41
// __block_44
_t___stage___block_39_cxtt = _q___pip_58_1_2___stage___block_3_cx+(_q___pip_58_1_2___stage___block_3_cy>>>3);

_t___stage___block_39_cytt = _q___pip_58_1_2___stage___block_3_cy-(_q___pip_58_1_2___stage___block_3_cx>>>3);

_t___stage___block_39_att = _q___pip_58_1_2___stage___block_3_a-5;

// __block_45
end
// 'after'
// __block_46
if (_t___stage___block_39_cytt[10+:1]) begin
// __block_47
// __block_49
_t___block_46_cxt = _t___stage___block_39_cxtt-(_t___stage___block_39_cytt>>>4);

_t___block_46_cyt = _t___stage___block_39_cytt+(_t___stage___block_39_cxtt>>>4);

_t___block_46_at = _t___stage___block_39_att+2;

// __block_50
end else begin
// __block_48
// __block_51
_t___block_46_cxt = _t___stage___block_39_cxtt+(_t___stage___block_39_cytt>>>4);

_t___block_46_cyt = _t___stage___block_39_cytt-(_t___stage___block_39_cxtt>>>4);

_t___block_46_at = _t___stage___block_39_att-2;

// __block_52
end
// 'after'
// __block_53
if (_t___block_46_cyt[10+:1]) begin
// __block_54
// __block_56
_d___pip_58_1_2___stage___block_3_cx = _t___block_46_cxt-(_t___block_46_cyt>>>5);

_d___pip_58_1_2___stage___block_3_cy = _t___block_46_cyt+(_t___block_46_cxt>>>5);

_d___pip_58_1_2___stage___block_3_a = _t___block_46_at+1;

// __block_57
end else begin
// __block_55
// __block_58
_d___pip_58_1_2___stage___block_3_cx = _t___block_46_cxt+(_t___block_46_cyt>>>5);

_d___pip_58_1_2___stage___block_3_cy = _t___block_46_cyt-(_t___block_46_cxt>>>5);

_d___pip_58_1_2___stage___block_3_a = _t___block_46_at-1;

// __block_59
end
// 'after'
// __block_60
// end of pipeline stage
// --- trickling
// -------- stage 3
// __stage___block_61
_t___stage___block_61_cx_6 = _q___pip_58_1_3___stage___block_3_cx>>5;









_t___stage___block_61_ma3 = (_q_effect==1 ? 1:0)|(_q_effect==2 ? 16:0)|(_q_effect==3 ? 4:0);






if (_w_vga_vga_x[0+:1]^_w_vga_vga_y[0+:1]) begin
// __block_62
// __block_64
_t___stage___block_61_ma12 = `_c___stage___block_61_ma1;

_t___stage___block_61_rseg12 = `_c___stage___block_61_rseg1;

_t___stage___block_61_d12 = $signed(`_c___stage___block_61_d1);

_t___stage___block_61_sh12 = ~`_c___stage___block_61_cmode;

// __block_65
end else begin
// __block_63
// __block_66
_t___stage___block_61_ma12 = `_c___stage___block_61_ma2;

_t___stage___block_61_rseg12 = `_c___stage___block_61_rseg2;

_t___stage___block_61_d12 = `_c___stage___block_61_d2;

_t___stage___block_61_sh12 = 1;

// __block_67
end
// 'after'
// __block_68

_t___block_68_df_12 = _t___stage___block_61_d12+_q_speed[0+:8];

_t___block_68_df_3 = `_c___stage___block_61_d3+_q_speed[0+:8];

_t___block_68_a_12 = _q___pip_58_1_3___stage___block_3_a+(_t___block_68_df_12[5+:1] ? -_t___stage___block_61_rseg12:_t___stage___block_61_rseg12);

_t___block_68_a_3 = _q___pip_58_1_3___stage___block_3_a+(_t___block_68_df_3[5+:1] ? -`_c___stage___block_61_rseg3:`_c___stage___block_61_rseg3);


_t___block_68_dfa_12 = `_c___stage___block_61_mk ? (`_c___block_68_dfs_12^8'd255):(`_c___block_68_dfs_12^_t___block_68_a_12);


_t___block_68_dfa_3 = `_c___stage___block_61_mk ? `_c___block_68_dfs_3:(`_c___block_68_dfs_3^_t___block_68_a_3);



if (~_t___block_68_dfa_12[5+:1]) begin
// __block_69
// __block_71
_t___block_68_frag12 = 0;

// __block_72
end else begin
// __block_70
// __block_73
_t___block_68_frag12 = `_c___block_68_c_12;

// __block_74
end
// 'after'
// __block_75
if (~_t___block_68_dfa_3[5+:1]) begin
// __block_76
// __block_78
_t___block_68_frag = _t___block_68_frag12>>1;

// __block_79
end else begin
// __block_77
// __block_80
_t___block_68_frag = `_c___block_68_c_3;

// __block_81
end
// 'after'
// __block_82
if (`_c___stage___block_61_mmode) begin
// __block_83
// __block_85
_t___block_68_frag = `_c___block_68_c_12+`_c___block_68_c_3;

// __block_86
end else begin
// __block_84
end
// 'after'
// __block_87


// end of pipeline stage
// --- trickling
_t___pip_58_1_3___block_87_atten_l = `_c___block_87_atten_l;
_t___pip_58_1_3___block_87_atten_h = `_c___block_87_atten_h;
_t___pip_58_1_3___block_68_frag = _t___block_68_frag;
// -------- stage 4
// __stage___block_88
_t___stage___block_88_p6 = {_w_vga_vga_x[0+:3],_w_vga_vga_y[0+:3]};

_t___stage___block_88_q6 = _t___stage___block_88_p6[0+:3]^_t___stage___block_88_p6[3+:3];


_t___stage___block_88_p4 = {_w_vga_vga_y[0+:2],_w_vga_vga_x[0+:2]};

_t___stage___block_88_q4 = _t___stage___block_88_p4[0+:2]^_t___stage___block_88_p4[2+:2];




_t___stage___block_88_c = _q___pip_58_1_4___stage___block_3_cx[9+:1]||(_q___pip_58_1_4___stage___block_3_cx[1+:6]>`_c___stage___block_88_bval6) ? `_c___stage___block_88_c1b:`_c___stage___block_88_c1a;




_t___stage___block_88_r_logo = {8'b0,_c_logo[_w_vga_vga_y[5+:2]],8'b0};

_t___stage___block_88_p_logo = _t___stage___block_88_r_logo[{_w_vga_vga_x[5+:5],2'b00}+:4];







_t_video_r = _w_vga_active ? _q_prev_r[{2'd3-_q___pip_58_1_4___block_87_atten_l,1'b0}+:2]:0;

_t_video_g = _w_vga_active ? `_c___stage___block_88_final:0;

_t_video_b = _w_vga_active ? _q_prev_b[{_q___pip_58_1_4___block_87_atten_l,1'b0}+:2]:0;

_d_prev_b = {_q_prev_b[0+:6],`_c___stage___block_88_final};

_d_prev_r = {_q_prev_r[0+:6],`_c___stage___block_88_final};

// end of last pipeline stage
// --- trickling
// __block_89
// __block_90


_d_frame = `_c___block_90_frame_tick ? (_q_frame+1):_q_frame;

_d_prev_vs = _w_vga_vga_vs;

_d_th = (`_c___block_90_next_effect||~_q_go) ? 0:(`_c___block_90_frame_tick ? (_q_th+1):_q_th);

_d_speed = ((_q_effect!=2'd2)||~_q_go) ? {_d_frame,1'b0}:(`_c___block_90_frame_tick ? (_q_speed+1+(_q_speed>>6)):_q_speed);

_d_rot_en = ((`_c___block_90_frame_tick&&`_c___block_90_next_effect&&(_q_effect==2'd3))||_d_frame[12+:1]) ? ~_q_rot_en:_q_rot_en;

_d_effect = ~_q_go ? 2'd2:((`_c___block_90_frame_tick&`_c___block_90_next_effect) ? (_q_effect+1):_q_effect);

_d_go = _q_go|_d_frame[9+:1];

_t_video_hs = _w_vga_vga_hs;

_t_video_vs = _w_vga_vga_vs;

// __block_91
// _always_post
// pipeline stage triggers
end
// ==== wires ====
wire  [9:0] _c_inv_l[27:0];
assign _c_inv_l[0] = 1023;
assign _c_inv_l[1] = 937;
assign _c_inv_l[2] = 625;
assign _c_inv_l[3] = 468;
assign _c_inv_l[4] = 375;
assign _c_inv_l[5] = 312;
assign _c_inv_l[6] = 267;
assign _c_inv_l[7] = 234;
assign _c_inv_l[8] = 208;
assign _c_inv_l[9] = 187;
assign _c_inv_l[10] = 170;
assign _c_inv_l[11] = 156;
assign _c_inv_l[12] = 144;
assign _c_inv_l[13] = 133;
assign _c_inv_l[14] = 125;
assign _c_inv_l[15] = 117;
assign _c_inv_l[16] = 110;
assign _c_inv_l[17] = 104;
assign _c_inv_l[18] = 98;
assign _c_inv_l[19] = 93;
assign _c_inv_l[20] = 89;
assign _c_inv_l[21] = 85;
assign _c_inv_l[22] = 81;
assign _c_inv_l[23] = 78;
assign _c_inv_l[24] = 75;
assign _c_inv_l[25] = 72;
assign _c_inv_l[26] = 69;
assign _c_inv_l[27] = 66;
wire  [63:0] _c_logo[3:0];
assign _c_logo[0] = 64'b0010111100010000001011110001000000101111000100000010000000000001;
assign _c_logo[1] = 64'b1111000011110000111100001111000011110000111100001111000000001111;
assign _c_logo[2] = 64'b1000111111110000100011111111000011111111111100001111001000011111;
assign _c_logo[3] = 64'b0000000010000000001001001000000010000000010000001000010010000100;
// ===============

always @(posedge clock) begin
_q_frame <= (reset) ? 0 : _d_frame;
_q_go <= (reset) ? 0 : _d_go;
_q_speed <= _d_speed;
_q_prev_vs <= _d_prev_vs;
_q_prev_b <= _d_prev_b;
_q_prev_r <= _d_prev_r;
_q_th <= _d_th;
_q_effect <= (reset) ? 2 : _d_effect;
_q_rot_en <= (reset) ? 0 : _d_rot_en;
_q___pip_58_1_4___block_68_frag <= _t___pip_58_1_3___block_68_frag;
_q___pip_58_1_4___block_87_atten_h <= _t___pip_58_1_3___block_87_atten_h;
_q___pip_58_1_4___block_87_atten_l <= _t___pip_58_1_3___block_87_atten_l;
_q___pip_58_1_1___stage___block_3_a <= _t___pip_58_1_0___stage___block_3_a;
_q___pip_58_1_2___stage___block_3_a <= _d___pip_58_1_1___stage___block_3_a;
_q___pip_58_1_3___stage___block_3_a <= _d___pip_58_1_2___stage___block_3_a;
_q___pip_58_1_1___stage___block_3_cx <= _t___pip_58_1_0___stage___block_3_cx;
_q___pip_58_1_2___stage___block_3_cx <= _d___pip_58_1_1___stage___block_3_cx;
_q___pip_58_1_3___stage___block_3_cx <= _d___pip_58_1_2___stage___block_3_cx;
_q___pip_58_1_4___stage___block_3_cx <= _d___pip_58_1_3___stage___block_3_cx;
_q___pip_58_1_1___stage___block_3_cy <= _t___pip_58_1_0___stage___block_3_cy;
_q___pip_58_1_2___stage___block_3_cy <= _d___pip_58_1_1___stage___block_3_cy;
end

endmodule


module M_main (
in_ui,
out_uo,
inout_uio_oe,
inout_uio_i,
inout_uio_o,
in_run,
out_done,
reset,
out_clock,
clock
);
input  [7:0] in_ui;
output  [7:0] out_uo;
output  [7:0] inout_uio_oe;
input  [7:0] inout_uio_i;
output  [7:0] inout_uio_o;
input in_run;
output out_done;
input reset;
output out_clock;
input clock;
wire __unused_in_run = in_run;
wire __unused_ui = &{1'b0,in_ui};
wire __unused_uio = &{1'b0,inout_uio_i};
assign out_clock = clock;
wire  [1:0] _w_demo_video_r;
wire  [1:0] _w_demo_video_g;
wire  [1:0] _w_demo_video_b;
wire  [0:0] _w_demo_video_hs;
wire  [0:0] _w_demo_video_vs;
wire  [7:0] _w_demo_audio8;
wire  [0:0] _w_demo_audio1;
wire __unused__demo = &{_w_demo_video_r,_w_demo_video_g,_w_demo_video_b,_w_demo_video_hs,_w_demo_video_vs,_w_demo_audio8,_w_demo_audio1,1'b0};

reg  [7:0] _d_uio_o;
reg  [7:0] _q_uio_o;
reg  [7:0] _d_uio_oenable;
reg  [7:0] _q_uio_oenable;
reg  [7:0] _d_uo;
reg  [7:0] _q_uo;
assign out_uo = _q_uo;
assign out_done = 0;
M_vga_demo_M_main_demo demo (
.out_video_r(_w_demo_video_r),
.out_video_g(_w_demo_video_g),
.out_video_b(_w_demo_video_b),
.out_video_hs(_w_demo_video_hs),
.out_video_vs(_w_demo_video_vs),
.out_audio8(_w_demo_audio8),
.out_audio1(_w_demo_audio1),
.reset(reset),
.clock(clock),.out_clock()
);


assign inout_uio_oe[0] = _q_uio_oenable[0];
assign inout_uio_o[0] = _q_uio_o[0];
assign inout_uio_oe[1] = _q_uio_oenable[1];
assign inout_uio_o[1] = _q_uio_o[1];
assign inout_uio_oe[2] = _q_uio_oenable[2];
assign inout_uio_o[2] = _q_uio_o[2];
assign inout_uio_oe[3] = _q_uio_oenable[3];
assign inout_uio_o[3] = _q_uio_o[3];
assign inout_uio_oe[4] = _q_uio_oenable[4];
assign inout_uio_o[4] = _q_uio_o[4];
assign inout_uio_oe[5] = _q_uio_oenable[5];
assign inout_uio_o[5] = _q_uio_o[5];
assign inout_uio_oe[6] = _q_uio_oenable[6];
assign inout_uio_o[6] = _q_uio_o[6];
assign inout_uio_oe[7] = _q_uio_oenable[7];
assign inout_uio_o[7] = _q_uio_o[7];

`ifdef FORMAL
initial begin
assume(reset);
end
`endif
always @* begin
_d_uio_o = _q_uio_o;
_d_uio_oenable = _q_uio_oenable;
_d_uo = _q_uo;
// _always_pre
// __block_1
_d_uo[7+:1] = _w_demo_video_hs;

_d_uo[3+:1] = _w_demo_video_vs;

_d_uo[4+:1] = _w_demo_video_r[0+:1];

_d_uo[0+:1] = _w_demo_video_r[1+:1];

_d_uo[5+:1] = _w_demo_video_g[0+:1];

_d_uo[1+:1] = _w_demo_video_g[1+:1];

_d_uo[6+:1] = _w_demo_video_b[0+:1];

_d_uo[2+:1] = _w_demo_video_b[1+:1];

_d_uio_oenable = {1'b1,7'b0};

_d_uio_o[7+:1] = _w_demo_audio1;

// __block_2
// _always_post
// pipeline stage triggers
end

always @(posedge clock) begin
_q_uio_o <= _d_uio_o;
_q_uio_oenable <= _d_uio_oenable;
_q_uo <= _d_uo;
end

endmodule


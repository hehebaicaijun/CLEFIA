module CLEFIA_top(                     
    input                       clk,
    input                       rst_n,
    input           [127:0]     din,        //data in, plaintext
    input           [127:0]     key,        //K
    input                       din_valid,
    output  reg     [127:0]     dout,       //data out, ciphertext
    output  reg                 dout_valid
);

//parameter define
    localparam                  HOLD = 3'b000;
    localparam                  K_INPUT = 3'b001;
    localparam                  K_CYCLE = 3'b010;
    localparam                  DATA_INPUT = 3'b011;
    localparam                  DATA_CYCLE = 3'b100;

//wire define
    wire            [127:0]     RK;          //RK0~3, RK=[RK0 RK1 RK2 RK3]
    wire            [127:0]     RK_CON;
    wire                        RK_CONTROL;
    wire            [127:0]     L;           //L from K
    wire            [127:0]     L_DS;        //L after DoubleSwaping
    wire            [ 31:0]     WK     [3:0];
    wire            [127:0]     xorpre_din;
    wire            [127:0]     xorpre_dout;
    wire            [127:0]     mux_dout;
    wire            [127:0]     GFN_dout;
    wire            [ 63:0]     GFN_RK;
    wire            [ 63:0]     GFN_CON;
    wire            [127:0]     shift_dout;
    wire            [127:0]     xorpost_dout;


//reg define
    reg             [127:0]     din_reg;
    reg             [127:0]     key_reg;
    reg             [  2:0]     state;
    reg                         ctrl0;
    reg                         ctrl1;
    reg                         ctrl2;
    reg                         ctrl3;
    reg                         counter;
    reg             [  3:0]     r_k; //r=12 for generating L
    reg             [  4:0]     r_d;//r=18 for data
    reg                         L_valid;
    reg             [127:0]     L_reg;
    reg                         L_cnt;
    reg             [127:0]     GFN_din_reg;
    reg             [ 63:0]     GFN_RK_reg;
    reg                         dout_valid0;


//input
always@(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        din_reg <= 0;
        key_reg <= 0;
    end
    else begin
        if(din_valid) begin
            din_reg <= din;
            key_reg <= key;
        end
        else begin
            din_reg <= 0;
            key_reg <= 0;
        end
    end
end


//K=[WK0 WK1 WK2 WK3]
assign WK[0] = key_reg[127:96];
assign WK[1] = key_reg[ 95:64];
assign WK[2] = key_reg[ 63:32];
assign WK[3] = key_reg[ 31: 0];


//state machine
always@(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
         counter <= 0; L_valid <= 0; dout_valid0 <= 0;
         ctrl0 <= 0; ctrl1 <= 0; ctrl2 <= 0; ctrl3 <= 0; 
         r_k <= 0; r_d <= 0;
         state <= HOLD;
    end
    else begin
        case(state)
            HOLD : begin
                dout_valid0 <= 0;
                ctrl0 <= 0; ctrl1 <= 0; ctrl2 <= 0; ctrl3 <= 0;
                r_k <= 0; r_d <= 0;
                if(din_valid)
                    state <= K_INPUT;
                else
                    state <= HOLD;
            end

            K_INPUT : begin
                if(din_valid) begin
                    ctrl0 <= 0; ctrl1 <= 0; ctrl2 <= 0;
                    r_k <= 1;
                    if(counter == 1) begin
                        counter <= 0;
                        state <= K_CYCLE;
                    end
                    else begin
                        counter <= counter + 1;
                        state <= K_INPUT;//one more clk cycle for this state 
                    end
                end
                else
                    state <= HOLD;
            end

            K_CYCLE : begin
                if(din_valid) begin
                    ctrl0 <= 0; ctrl1 <= 1; ctrl2 <= 0;
                    if(r_k < 12) begin
                        r_k <= r_k + 1;
                        state <= K_CYCLE;
                    end
                    else begin
                        L_valid <= 1;
                        r_k <= 0;        
                        state <= DATA_INPUT;
                    end
                end
                else
                    state <= HOLD;
            end

            DATA_INPUT : begin
                if(din_valid) begin
                    L_valid <= 0;
                    ctrl0 <= 1; ctrl1 <= 0; ctrl2 <= 1; ctrl3 <= r_d[0];
                    if(counter == 1) begin
                        counter <= 0;
                        r_d <= 1;
                        state <= DATA_CYCLE;
                    end
                    else begin
                        counter <= counter + 1;
                        state <= DATA_INPUT;//one more clk cycle for this state 
                    end
                end
                else
                    state <= HOLD;
            end

            DATA_CYCLE : begin
                if(din_valid) begin
                    ctrl0 <= 1; ctrl1 <= 1; ctrl2 <= 1; ctrl3 <= r_d[0];
                    if(r_d < 18) begin
                        r_d <= r_d + 1;
                        state <= DATA_CYCLE;
                    end
                    else begin
                        dout_valid0 <= 1;
                        r_d <= 0;        
                        state <= HOLD;
                    end
                end
                else
                    state <= HOLD;
            end
        endcase
    end
end


//whitening input data: din ^ wk
assign xorpre_din = din_reg;

xorpre u0(
    .din(xorpre_din),
    .WK0(WK[0]),
    .WK1(WK[1]),
    .dout(xorpre_dout)
);


//generate GFN_CON, CON0 ~ 23
//generate RK_CON, CON24 ~ 59
CON_0to23 u6(
    .Round(r_k),
    .CON(GFN_CON)
);

CON_24to59 u7(
    .Round(r_d),
    .CON(RK_CON)
);


//logic for Key_Scheduling's cycle
always@(posedge clk or negedge rst_n) begin
    if(~rst_n)
        L_cnt <= 0;
    else begin
        if(r_d != 0) begin
            if(L_cnt == 1)
                L_cnt <= 0;
            else
                L_cnt <= L_cnt + 1;
        end
        else
            L_cnt <= 0;
    end
end

always@(posedge clk or negedge rst_n) begin
    if(~rst_n)
        L_reg <= 0;
    else begin
        if( (L_cnt == 1) | L_valid )
            L_reg <= L;
        else
            L_reg <= L_reg;
    end
end

assign L = (L_valid) ? GFN_dout : L_DS;
assign RK_CONTROL = r_d[1] ^ r_d[0];


//Key_Scheduling: generate RK0~35
//CONTROL active means RK = L ^ CON ^ K; otherwise, RK = L ^ CON
Key_Scheduling u5(
    .K(key),
    .L(L_reg),
    .CON(RK_CON),
    .CONTROL(RK_CONTROL),
    .RK(RK),
    .L_DS(L_DS)
);


//main processing: GFNs
//L = GFN4,12(K, CON0~23)
//dout = GFN4,18(din, RK0~35)
//ctrl0 = 1 for first data, 0 for first key
//ctrl1 = 1 for cycle, 0 for first input 
//ctrl2 = 1 for ciphering data, 0 for generating L
assign mux_dout = ctrl1 ? shift_dout : (ctrl0 ? xorpre_dout : key_reg); 
assign GFN_RK = ctrl2 ? (ctrl3 ? RK[63:0] : RK[127:64]) : GFN_CON;

always@(posedge clk or negedge rst_n) begin
    if(~rst_n)
        GFN_din_reg <= 0;
    else    
        GFN_din_reg <= mux_dout;
end

always@(posedge clk or negedge rst_n) begin
    if(~rst_n) 
        GFN_RK_reg <= 0;
    else    
        GFN_RK_reg <= GFN_RK;
end

GFN u2(
    .din    (GFN_din_reg),
    .dout   (GFN_dout),
    .RK     (GFN_RK_reg)
);


//shift GFN output for cycle
//xor GFN output for L or Data
shift u3(
    .din    (GFN_dout),
    .dout   (shift_dout)
);

xorpost u4(
    .din(GFN_dout),
    .WK2(WK[2]),
    .WK3(WK[3]),
    .dout(xorpost_dout)
);


//output reg
//dout_valid have been define in the state machine
always@(posedge clk or negedge rst_n) begin
    if(~rst_n)
        dout_valid <= 0;
    else begin
        if(dout_valid0)
            dout_valid <= 1;
        else
            dout_valid <= dout_valid;
    end
end

always@(posedge clk or negedge rst_n) begin
    if(~rst_n)
        dout <= 0;
    else begin
        if(dout_valid0)
            dout <= xorpost_dout;
        else
            dout <= dout;
    end
end

endmodule
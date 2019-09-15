module Traffic_Light_Controller (clk, rst_n, lr_has_car, hw_light, lr_light, state, counter);
    input clk, rst_n;
    input lr_has_car;
    output [3-1:0] hw_light;
    output [3-1:0] lr_light;
    output [2:0]state;
    output [4:0]counter;

    reg [4:0] counter, next_counter;
    reg [2:0] state, next_state;
    reg [2:0] hw_light, lr_light;

    parameter [2:0] A = 3'd0;
    parameter [2:0] B = 3'd1;
    parameter [2:0] C = 3'd2;
    parameter [2:0] D = 3'd3;
    parameter [2:0] E = 3'd4;
    parameter [2:0] F = 3'd5;

    always@(posedge clk)begin
        if(!rst_n)begin
            counter <= 5'd1; //0?
            state <= A;
        end
        else begin
            counter <= next_counter;
            state <= next_state;
        end
    end

    always@(*)begin
        case(state)
            A:begin
                hw_light = 3'b001;
                lr_light = 3'b100;
                if(lr_has_car == 1)begin
                    if(counter >= 5'd25)begin
                        next_state = B;
                        next_counter = 5'd1;
                    end
                    else begin
                        next_state = A;
                        next_counter = counter + 1;
                    end
                end
                else begin
                    next_counter = counter + 1;
                    next_state = A;
                end
            end
            B:begin
                hw_light = 3'b010;
                lr_light = 3'b100;
                if(counter == 5'd5)begin
                    next_counter = 5'd1;
                    next_state = C;
                end
                else begin
                    next_counter = counter + 1;
                    next_state = B;
                end
            end
            C:begin
                hw_light = 3'b100;
                lr_light = 3'b100;
                next_counter = 5'd1;
                next_state = D;
            end
            D:begin
                hw_light = 3'b100;
                lr_light = 3'b001;
                if(counter == 5'd25)begin
                    next_state = E;
                    next_counter = 5'd1;
                end
                else begin
                    next_state = D;
                    next_counter = counter + 1;
                end
            end
            E:begin
                hw_light = 3'b100;
                lr_light = 3'b010;
                if(counter == 5'd5)begin
                    next_counter = 5'd1;
                    next_state = F;
                end
                else begin
                    next_counter = counter + 1;
                    next_state = E;
                end
            end
            F:begin
                hw_light = 3'b100;
                lr_light = 3'b100;
                next_counter = 5'd1;
                next_state = A;
            end
        endcase
    end

endmodule
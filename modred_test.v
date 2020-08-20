
module modred_test();

reg [23:0] C;
wire[11:0] R;

modred uut(C,R);

integer es;
integer ex;

initial begin
    C = 0;

    #100;

    for(es=0; es<(3329*3329); es=es+1) begin
        C = es;
        ex= es % 3329;
        #1;
        if(R != ex) begin
            $display("Fail! Expected=%d - Calculated=%d",ex,R);
            $stop;
        end
        #1;
    end
    $display("Success!");
    $finish;
end

endmodule


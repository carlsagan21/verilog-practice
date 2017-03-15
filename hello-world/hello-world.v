module hello_world;
  initial
    begin
      $dumpfile("hello-world.vcd");
      $dumpvars(0, hello_world);

      $display("Hello, World");
      $finish;
    end
endmodule

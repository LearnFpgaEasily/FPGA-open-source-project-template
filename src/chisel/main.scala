import chisel3._


class AlchitryCUTop extends Module {
    val io = IO(new Bundle{
        val led = Output(UInt(1.W))
    })
    // the alchitry CU board has an active low reset
    val reset_n = !reset.asBool

    withReset(reset_n){
        val my_reg = RegInit(0.U(1.W))
        my_reg := 1.U
        io.led := my_reg
    }
    
}

object Main extends App{
    (new chisel3.stage.ChiselStage).emitVerilog(new AlchitryCUTop, Array("--target-dir", "build/artifacts/netlist/"))
}
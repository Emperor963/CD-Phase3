/*                              +-------------------+
                             |                   |
               enable >------|                   |
           index[7:0] >------|    cache          |
          offset[2:0] >------|                   |
                 comp >------|    256 lines      |-----> hit
                write >------|    by 4 words     |-----> dirty
          tag_in[4:0] >------|                   |-----> tag_out[4:0]
        data_in[15:0] >------|                   |-----> data_out[15:0]
             valid_in >------|                   |-----> valid
                             |                   |
                  clk >------|                   |
                  rst >------|                   |-----> err
           createdump >------|                   |
                             +-------------------+  */

module cache (
    input enable,
    input index[7:0],
    input offset[2:0],
    input comp,
    input write,
    input tag_in[4:0],
    input data_in[15:0],
    input valid _in,
    input clk,
    input rst,
    input createdump,

    output hit,
    output dirty,
    output tag_out[4:0],
    output data_out[15:0],
    output valid,
    output err
);


endmodule





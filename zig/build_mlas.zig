const utils = @import("build_helper.zig");
const BuildCtx = utils.BuildCtx;
const std = @import("std");
const cpu_feature = @import("cpu_feature.zig");

fn addCSourceFiles(ctx: *BuildCtx, files: []const []const u8) void {
    const root_path = ctx.b.path("onnxruntime/core/mlas/lib");
    const cflags = &.{ "-Ionnxruntime/core/mlas/inc", "-Ionnxruntime/core/mlas/lib" };
    ctx.ort.addCSourceFiles(.{ .root = root_path, .flags = cflags, .files = files });
}

pub fn build(ctx: *BuildCtx) void {
    addCSourceFiles(ctx, &.{
        "platform.cpp",
        "threading.cpp",
        "sgemm.cpp",
        "halfgemm.cpp",
        "qgemm.cpp",
        "qdwconv.cpp",
        "convolve.cpp",
        "convsym.cpp",
        "pooling.cpp",
        "transpose.cpp",
        "reorder.cpp",
        "snchwc.cpp",
        "activate.cpp",
        "logistic.cpp",
        "tanh.cpp",
        "erf.cpp",
        "compute.cpp",
        "quantize.cpp",
        "qgemm_kernel_default.cpp",
        "qladd.cpp",
        "qlmul.cpp",
        "qpostprocessor.cpp",
        "qlgavgpool.cpp",
        "qdwconv_kernelsize.cpp",
        "sqnbitgemm.cpp",
        "flashattn.cpp",

        // not minimal build
        "q4_dq.cpp",
        "q4gemm.cpp",
    });

    if (ctx.target.result.cpu.arch.isARM()) {
        addCSourceFiles(ctx, &.{
            "aarch32/QgemmU8X8KernelNeon.S",
            "arm/sgemmc.cpp",
            "qgemm_kernel_neon.cpp",
        });
    }

    if (ctx.target.result.cpu.arch.isAARCH64()) {
        addCSourceFiles(ctx, &.{
            "aarch64/ConvSymS8KernelDot.S",
            "aarch64/ConvSymS8KernelDotLd64.S",
            "aarch64/ConvSymU8KernelDot.S",
            "aarch64/ConvSymS8KernelNeon.S",
            "aarch64/ConvSymU8KernelNeon.S",
            "aarch64/DepthwiseQConvSymS8KernelNeon.S",
            "aarch64/DepthwiseQConvSymU8KernelNeon.S",
            "aarch64/DepthwiseQConvKernelSize9Neon.S",
            "aarch64/QgemmU8X8KernelNeon.S",
            "aarch64/QgemmS8S8KernelNeon.S",
            "aarch64/QgemmU8X8KernelUdot.S",
            "aarch64/QgemmS8S8KernelSdot.S",
            "aarch64/SgemmKernelNeon.S",
            "aarch64/SgemvKernelNeon.S",
            "aarch64/SymQgemmS8KernelNeon.S",
            "aarch64/SymQgemmS8KernelSdot.S",
            "aarch64/SymQgemmS8KernelSdotLd64.S",
            "qgemm_kernel_neon.cpp",
            "qgemm_kernel_udot.cpp",
            "qgemm_kernel_sdot.cpp",
            "sqnbitgemm_kernel_neon.h",
            "sqnbitgemm_kernel_neon.cpp",
            "sqnbitgemm_kernel_neon_fp32.cpp",
            "sqnbitgemm_kernel_neon_int8.cpp",
            "sqnbitgemm_kernel_neon_int8.cpp",
        });

        if (!ctx.target.result.isDarwin()) {
            addCSourceFiles(ctx, &.{
                "aarch64/HalfGemmKernelNeon.S",
                "aarch64/QgemmS8S8KernelSmmla.S",
                "aarch64/QgemmU8X8KernelUmmla.S",
                "aarch64/SbgemmKernelNeon.S",
                "activate_fp16.cpp",
                "dwconv.cpp",
                "halfgemm_kernel_neon.cpp",
                "pooling_fp16.cpp",
                "qgemm_kernel_smmla.cpp",
                "qgemm_kernel_ummla.cpp",
                "sbgemm_kernel_neon.cpp",
            });
        }
    }

    if (ctx.target.result.cpu.arch == .x86) {
        addCSourceFiles(ctx, &.{
            "qgemm_kernel_sse.cpp",
            "x86/SgemmKernelSse2.S",
            "x86/SgemmKernelAvx.S",
        });
    }

    if (ctx.target.result.cpu.arch == .x86_64) {
        addCSourceFiles(ctx, &.{
            "qgemm_kernel_sse.cpp",
            "x86_64/DgemmKernelSse2.S",
            "x86_64/SgemmKernelSse2.S",
            "x86_64/SgemmTransposePackB16x4Sse2.S",
            "x86_64/SconvKernelSse2.S",
            "x86_64/SpoolKernelSse2.S",

            "x86_64/DgemmKernelAvx.S",
            "x86_64/SgemmKernelAvx.S",
            "x86_64/SgemmKernelM1Avx.S",
            "x86_64/SgemmKernelM1TransposeBAvx.S",
            "x86_64/SgemmTransposePackB16x4Avx.S",
            "x86_64/SconvKernelAvx.S",
            "x86_64/SpoolKernelAvx.S",
            "x86_64/SoftmaxKernelAvx.S",
            "intrinsics/avx/min_max_elements.cpp",

            "x86_64/QgemmU8S8KernelAvx2.S",
            "x86_64/QgemvU8S8KernelAvx2.S",
            "x86_64/QgemmU8U8KernelAvx2.S",
            "x86_64/QgemvU8S8KernelAvxVnni.S",
            "x86_64/QgemmU8X8KernelAvx2.S",
            "x86_64/ConvSymKernelAvx2.S",
            "x86_64/DgemmKernelFma3.S",
            "x86_64/SgemmKernelFma3.S",
            "x86_64/SconvKernelFma3.S",
            "x86_64/TransKernelFma3.S",
            "x86_64/LogisticKernelFma3.S",
            "x86_64/TanhKernelFma3.S",
            "x86_64/ErfKernelFma3.S",
            "intrinsics/avx2/qladd_avx2.cpp",
            "intrinsics/avx2/qdwconv_avx2.cpp",
            "sqnbitgemm_kernel_avx2.cpp",
        });

        addCSourceFiles(ctx, &.{
            "activate_fp16.cpp",
            "dwconv.cpp",
            "dgemm.cpp",
            "pooling_fp16.cpp",
            "qgemm_kernel_avx2.cpp",
        });

        if (cpu_feature.have_x86_feat_all(ctx.target.result, &.{.avx512f})) {
            addCSourceFiles(ctx, &.{
                "x86_64/DgemmKernelAvx512F.S",
                "x86_64/SgemmKernelAvx512F.S",
                "x86_64/SconvKernelAvx512F.S",
                "x86_64/SoftmaxKernelAvx512F.S",
                "x86_64/SpoolKernelAvx512F.S",
                "x86_64/TransKernelAvx512F.S",
                "intrinsics/avx512/quantize_avx512f.cpp",
            });

            if (cpu_feature.have_x86_feat_all(ctx.target.result, &.{ .avx512vnni, .avx512bw, .avx512dq, .avx512vl, .avx512f })) {
                addCSourceFiles(ctx, &.{
                    "x86_64/QgemvU8S8KernelAvx512Core.S",
                    "x86_64/QgemvU8S8KernelAvx512Vnni.S",
                    "x86_64/QgemmU8X8KernelAvx512Core.S",
                    "x86_64/ConvSymKernelAvx512Core.S",
                    "sqnbitgemm_kernel_avx512.cpp",
                    "q4gemm_avx512.cpp",
                    "sqnbitgemm_kernel_avx512vnni.cpp",
                });

                if (!ctx.target.result.isDarwin()) {
                    addCSourceFiles(ctx, &.{
                        "x86_64/QgemmU8S8KernelAmxCommon.S",
                        "qgemm_kernel_amx.cpp",
                        "x86_64/QgemmU8S8KernelAmx.S",
                    });
                }
            }
        }
    }
}

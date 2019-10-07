#!/usr/bin/env nextflow
/*
==============================
Fecha: MAR 20
Version: 0.001
Autores: Judith Ballesteros Villascán
Descripción: Know the snps shared between data sets of population projects.
GIT Repository:
==============================
INITIALIZE PARAMETERS

==============================
Pipeline processes in brief:
Pre-Processing:
_pre1_prepare_vcfs
_pre2_concatenate_vcfs
_pre3_compress_vcfs
Core-Processing:
_001_
_002_
_003_
Post-Processing:
_pst1_
==============================
*/

/*
PIPELINE START
*/
/* DEFINE INPUT PATHS
/* Load feature files into channel*/
Channel
  .fromPath( "${params.input_dir}/*.vcf.gz" )
//   .println()
   .set{feature_files_inputs}
  // set es una manera de decirle cierra el canal y guardalo con este nombre de objeto
/*
===========================================
Process for preparing vcfs format files:
===========================================
*/
/* Loading mkfiles*/
Channel
  .fromPath("mkmodules/mk-prepare-vcfs/*")
//  .println()
    .toList()
    .set{mkfiles_pre1}

process _pre1_prepare_vcfs {
  //echo true
  //maxForks 1 limita el numero de procesos a enviar
  publishDir "test/results/_pre1_prepare-vcfs/", mode: "copy"
  input: //canales de donde vienen los datos
    file vcfs from feature_files_inputs
    file mkfiles from mkfiles_pre1
    output:
    //declarar canal de salida
     file "*.simplified.vcf.g*" into results_pre1_prepare_vcfs
   """
    #echo "este es un nuevo dir de trabajo"
    bash runmk.sh
    #ls
    """
}

/*
=========================================================
Process for concatenating vcfs files:
=========================================================
*/
/* Preparar inputs */
results_pre1_prepare_vcfs
  .view()
  .toList()
  .view()
  .set{inputs_for_pre2}
/* Load mkfiles */

Channel
  .fromPath("mkmodules/mk-concatenate-vcfs/*")
    .toList()
    .view()
    .set{mkfiles_pre2}

process _pre2_concatenate{
  publishDir "test/results/_pre2_concatenate/", mode: "copy"
  input:
  file simplified_vcf from inputs_for_pre2
  file mkfiles from mkfiles_pre2
  output:
  file "concatenated.vcf" into results_pre2_concatenate_vcfs

  """
  bash runmk.sh
  """
}

/*
=========================================================
Process for compressing vcf:
=========================================================
*/
/* Preparar inputs */
results_pre2_concatenate_vcfs
  .view()
  .toList()
  .view()
  .set{inputs_for_pre3}
/* Load mkfiles */

Channel
  .fromPath("mkmodules/mk-compress-vcfs/*")
    .toList()
    .view()
    .set{mkfiles_pre3}

process _pre3_compress_vcfs{
  publishDir "test/results/_pre3_compress_vcfs/", mode: "copy"
  input:
  file simplified_concatenated_vcf from inputs_for_pre3
  file mkfiles from mkfiles_pre3
  output:
  file "*.sorted.normalized.split_multiallelics.vcf.gz*" into results_pre3_compress_vcfs

  """
  export GENOME_REFERENCE="${params.genome_reference}"
  bash runmk.sh
  """
}

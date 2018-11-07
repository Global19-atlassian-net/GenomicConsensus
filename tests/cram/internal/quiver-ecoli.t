
Run quiver on a large-insert C2 E. coli job.

  $ alias untabify="tr '\t' ' '"
  $ export INPUT=/mnt/secondary/Share/Quiver/TestData/ecoli/job_059531.cmp.h5
  $ export REFERENCE=/mnt/secondary/Share/Quiver/TestData/ecoli/ecoliK12_pbi_March2013.fasta

For some reason, this old cmp.h5 file lacks proper chemistry
information.  Quiver should reject it.

  $ quiver --notrace -j${JOBS-16} $INPUT -r $REFERENCE -o variants.gff -o css.fasta
  "unknown" chemistry in alignment file: either an unsupported chemistry has been used, the alignment file has been improperly constructed, or this version of SMRTanalysis is too old to recognize a new chemistry.
  [255]


Well, we know it was a C2 job, so let's force the issue

  $ quiver -p C2 -j${JOBS-16} $INPUT -r $REFERENCE -o variants.gff -o variants.vcf -o css.fasta

Inspect the variants list.  A few mutations seem to have crept in
since I built the new reference.

  $ cat variants.gff | untabify
  ##gff-version 3
  ##pacbio-variant-version 2.1
  ##date * (glob)
  ##feature-ontology http://song.cvs.sourceforge.net/*checkout*/song/ontology/sofa.obo?revision=1.12
  ##source GenomicConsensus * (glob)
  ##source-commandline * (glob)
  ##source-alignment-file * (glob)
  ##source-reference-file * (glob)
  ##sequence-region ecoliK12_pbi_March2013 1 4642522
  ecoliK12_pbi_March2013 . deletion 85 85 . . . reference=G;variantSeq=.;coverage=53;confidence=48
  ecoliK12_pbi_March2013 . deletion 219 219 . . . reference=A;variantSeq=.;coverage=58;confidence=47
  ecoliK12_pbi_March2013 . insertion 1536 1536 . . . reference=.;variantSeq=C;coverage=91;confidence=47

  $ cat variants.vcf | untabify
  ##fileformat=VCFv4.2
  ##fileDate=* (glob)
  ##source=GenomicConsensusV* (glob)
  ##reference=file://* (glob)
  ##contig=<ID=ecoliK12_pbi_March2013,length=4642522>
  ##INFO=<ID=DP,Number=1,Type=Integer,Description="Approximate read depth; some reads may have been filtered">
  ##FILTER=<ID=q40,Description="Quality below 40">
  ##FILTER=<ID=c5,Description="Coverage below 5">
  #CHROM POS ID REF ALT QUAL FILTER INFO
  ecoliK12_pbi_March2013 84 . TG T 48 PASS DP=53
  ecoliK12_pbi_March2013 218 . GA G 47 PASS DP=58
  ecoliK12_pbi_March2013 1536 . G GC 47 PASS DP=91

No no-call windows.

  $ fastacomposition css.fasta
  css.fasta A 1141540 C 1177642 G 1180362 T 1142977

MuMMer analysis.  No structural diffs

  $ nucmer -mum $REFERENCE css.fasta 2>/dev/null
  $ show-diff -H out.delta

SNPs same as variants

  $ show-snps -C -H out.delta | sed -E 's/[[:space:]]+/ /g'
   85 G . 84 | 85 84 | 1 1 ecoliK12_pbi_March2013 ecoliK12_pbi_March2013|quiver
   220 A . 218 | 135 218 | 1 1 ecoliK12_pbi_March2013 ecoliK12_pbi_March2013|quiver
   1536 . C 1535 | 1316 1535 | 1 1 ecoliK12_pbi_March2013 ecoliK12_pbi_March2013|quiver

from __future__ import absolute_import, division, print_function

from nose.tools import assert_equal as EQ
from GenomicConsensus.quiver.diploid import variantsFromAlignment
from GenomicConsensus.variants import Variant
import ConsensusCore as cc

def test_diploid_variantsFromAlignment():
    refWin = (0, 10, 17)

    EQ([],
       variantsFromAlignment(refWin, "GATTACA","GATTACA"))

    EQ([Variant(0, 13, 14, "T", "G", refPrev="T", readPrev="T")],
       variantsFromAlignment(refWin, "GATTACA","GATGACA"))

    EQ([Variant(0, 12, 14, "TT", "GG", refPrev="A", readPrev="A")],
       variantsFromAlignment(refWin, "GATTACA","GAGGACA"))

    EQ([Variant(0, 12, 13, "T", "G", refPrev="A", readPrev="A"),
        Variant(0, 14, 15, "A", "G", refPrev="T", readPrev="N")],
       variantsFromAlignment(refWin, "GATTACA","GAGNGCA"))

    EQ([Variant(0, 15, 16, "C", "", refPrev="A", readPrev="A")],
       variantsFromAlignment(refWin, "GATTACA","GATTAA"))

    EQ([Variant(0, 12, 12, "", "T", refPrev="A", readPrev="A")],
       variantsFromAlignment(refWin, "GATTACA","GATTTACA"))

    EQ([Variant(0, 13, 14, "T", "A", "T", refPrev="T", readPrev="T")],
       variantsFromAlignment(refWin, "GATTACA","GATWACA"))

    EQ([Variant(0, 12, 13, "T", "A", "T", refPrev="A", readPrev="A"),
        Variant(0, 13, 14, "T", "A", "T", refPrev="T", readPrev="W")],
       variantsFromAlignment(refWin, "GATTACA","GAWWACA"))

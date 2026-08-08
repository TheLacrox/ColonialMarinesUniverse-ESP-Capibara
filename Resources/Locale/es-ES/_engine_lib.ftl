# Used internally by the THE() function.
zzzz-the = { PROPER($ent) ->
    *[false] { GENDER($ent) ->
        [female] la
        [epicene] le
       *[other] el
    } { $ent }
     [true] { $ent }
    }

# Used internally by the SUBJECT() function.
zzzz-subject-pronoun = { GENDER($ent) ->
    [male] él
    [female] ella
    [epicene] elle
   *[neuter] ello
   }

# Used internally by the OBJECT() function.
zzzz-object-pronoun = { GENDER($ent) ->
    [male] lo
    [female] la
    [epicene] le
   *[neuter] lo
   }

# Used internally by the DAT-OBJ() function.
# Not used in en-US. Created to support other languages.
# (e.g., "to him," "for her")
zzzz-dat-object = { GENDER($ent) ->
    [male] le
    [female] le
    [epicene] le
   *[neuter] le
   }

# Used internally by the GENITIVE() function.
# Not used in en-US. Created to support other languages.
# e.g., "у него" (Russian), "seines Vaters" (German).
zzzz-genitive = { GENDER($ent) ->
    [male] de él
    [female] de ella
    [epicene] de elle
   *[neuter] de ello
   }

# Used internally by the POSS-PRONOUN() function.
zzzz-possessive-pronoun = { GENDER($ent) ->
    [male] suyo
    [female] suya
    [epicene] suye
   *[neuter] suyo
   }

# Used internally by the POSS-ADJ() function.
zzzz-possessive-adjective = { GENDER($ent) ->
    [male] su
    [female] su
    [epicene] su
   *[neuter] su
   }

# Used internally by the REFLEXIVE() function.
zzzz-reflexive-pronoun = { GENDER($ent) ->
    [male] sí mismo
    [female] sí misma
    [epicene] sí misme
   *[neuter] sí mismo
   }

# Used internally by the CONJUGATE-BE() function.
zzzz-conjugate-be = { GENDER($ent) ->
    [epicene] está
   *[other] está
   }

# Used internally by the CONJUGATE-HAVE() function.
zzzz-conjugate-have = { GENDER($ent) ->
    [epicene] tiene
   *[other] tiene
   }

# Used internally by the CONJUGATE-BASIC() function.
zzzz-conjugate-basic = { GENDER($ent) ->
    [epicene] { $second }
   *[other] { $second }
   }

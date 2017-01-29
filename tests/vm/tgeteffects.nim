discard """
  output: '''Raisable Exceptions:
Exception

Tags associated with:
Tag
GenericTag[int]
GenericTag[float]
true
'''
"""

import macros, typetraits

type
  Tag = object of RootObj
  GenericTag[T] = object
    i: T
  Alias = GenericTag[int]

proc hasTag() {. tags: [Tag] .} = discard
proc hasIntTag() {. tags: [GenericTag[int]] .} = discard
proc hasFloatTag() {. tags: [GenericTag[float]] .} = discard
proc raisesRootException() =
  if false:
    raise newException(Exception, "raising...")

proc hasSomeTags() =
  hasTag()
  hasIntTag()
  hasFloatTag()
  raisesRootException()

macro printTags(): untyped =
  let
    sym = bindsym"hasSomeTags"
    exceptions = getRaises(sym)
    tags = getTags(sym)
  result = newNimNode(nnkStmtList)

  echo "Raisable Exceptions:"
  for effect in exceptions:
    echo toStrLit(effect.getTypeInst)
  echo "\nTags associated with:"
  for effect in tags:
    echo toStrLit(effect)

  echo sym.hasTag(Alias)

printTags()

//
//  WeGoCuba-Bridging-Header.h
//  WeGoCuba
//
//  Created by Randy Hector Bartumeu Huergo on 9/7/17.
//  Copyright © 2017 Randy Hector Bartumeu Huergo. All rights reserved.
//

#import <CartoMobileSDK/CartoMobileSDK.h>

#import "J2ObjC_source.h"
#import "IOSClass.h"
#import "IOSObjectArray.h"

#import "com/graphhopper/GHRequest.h"
#import "com/graphhopper/GHResponse.h"
#import "com/graphhopper/GraphHopper.h"
#import "com/graphhopper/GraphHopperAPI.h"
#import "com/graphhopper/PathWrapper.h"

#import "com/graphhopper/coll/BinHeapWrapper.h"
#import "com/graphhopper/coll/CompressedArray.h"
#import "com/graphhopper/coll/GHBitSet.h"
#import "com/graphhopper/coll/GHBitSetImpl.h"
#import "com/graphhopper/coll/GHLongIntBTree.h"
#import "com/graphhopper/coll/GHSortedCollection.h"
#import "com/graphhopper/coll/GHTBitSet.h"
#import "com/graphhopper/coll/GHTreeMapComposed.h"
#import "com/graphhopper/coll/IntDoubleBinHeap.h"
#import "com/graphhopper/coll/LongIntMap.h"
#import "com/graphhopper/coll/MapEntry.h"
#import "com/graphhopper/coll/OSMIDMap.h"
#import "com/graphhopper/coll/OTPIntDoubleBinHeap.h"
#import "com/graphhopper/coll/SparseIntIntArray.h"

#import "com/graphhopper/geohash/KeyAlgo.h"
#import "com/graphhopper/geohash/LinearKeyAlgo.h"
#import "com/graphhopper/geohash/SpatialKeyAlgo.h"

#import "com/graphhopper/reader/DataReader.h"

#import "com/graphhopper/reader/dem/BridgeElevationInterpolator.h"
#import "com/graphhopper/reader/dem/CGIARProvider.h"
#import "com/graphhopper/reader/dem/ElevationProvider.h"
#import "com/graphhopper/reader/dem/SRTMProvider.h"
#import "com/graphhopper/reader/dem/TunnelElevationInterpolator.h"

#import "com/graphhopper/routing/AlgorithmOptions.h"
#import "com/graphhopper/routing/QueryGraph.h"
#import "com/graphhopper/routing/RoutingAlgorithmFactory.h"
#import "com/graphhopper/routing/RoutingAlgorithmFactoryDecorator.h"
#import "com/graphhopper/routing/RoutingAlgorithmFactorySimple.h"

#import "com/graphhopper/routing/ch/CHAlgoFactoryDecorator.h"
#import "com/graphhopper/routing/ch/PrepareContractionHierarchies.h"

#import "com/graphhopper/routing/subnetwork/PrepareRoutingSubnetworks.h"

#import "com/graphhopper/routing/template/AlternativeRoutingTemplate.h"
#import "com/graphhopper/routing/template/RoundTripRoutingTemplate.h"
#import "com/graphhopper/routing/template/RoutingTemplate.h"
#import "com/graphhopper/routing/template/ViaRoutingTemplate.h"

#import "com/graphhopper/routing/util/AllEdgesIterator.h"
#import "com/graphhopper/routing/util/DataFlagEncoder.h"
#import "com/graphhopper/routing/util/EncodingManager.h"
#import "com/graphhopper/routing/util/FlagEncoder.h"
#import "com/graphhopper/routing/util/FlagEncoderFactory.h"
#import "com/graphhopper/routing/util/HintsMap.h"
#import "com/graphhopper/routing/util/TraversalMode.h"

#import "com/graphhopper/routing/weighting/CurvatureWeighting.h"
#import "com/graphhopper/routing/weighting/FastestWeighting.h"
#import "com/graphhopper/routing/weighting/GenericWeighting.h"
#import "com/graphhopper/routing/weighting/PriorityWeighting.h"
#import "com/graphhopper/routing/weighting/ShortFastestWeighting.h"
#import "com/graphhopper/routing/weighting/ShortestWeighting.h"
#import "com/graphhopper/routing/weighting/TurnWeighting.h"
#import "com/graphhopper/routing/weighting/Weighting.h"

#import "com/graphhopper/storage/CHGraph.h"
#import "com/graphhopper/storage/DAType.h"
#import "com/graphhopper/storage/Directory.h"
#import "com/graphhopper/storage/GHDirectory.h"
#import "com/graphhopper/storage/Graph.h"
#import "com/graphhopper/storage/GraphExtension.h"
#import "com/graphhopper/storage/GraphHopperStorage.h"
#import "com/graphhopper/storage/Lock.h"
#import "com/graphhopper/storage/LockFactory.h"
#import "com/graphhopper/storage/NativeFSLockFactory.h"
#import "com/graphhopper/storage/SimpleFSLockFactory.h"
#import "com/graphhopper/storage/StorableProperties.h"
#import "com/graphhopper/storage/TurnCostExtension.h"
#import "com/graphhopper/storage/index/LocationIndex.h"
#import "com/graphhopper/storage/index/LocationIndexTree.h"

#import "com/graphhopper/util/AngleCalc.h"
#import "com/graphhopper/util/CmdArgs.h"
#import "com/graphhopper/util/ConfigMap.h"
#import "com/graphhopper/util/Constants.h"
#import "com/graphhopper/util/DouglasPeucker.h"
#import "com/graphhopper/util/GHUtility.h"
#import "com/graphhopper/util/Helper.h"
#import "com/graphhopper/util/Instruction.h"
#import "com/graphhopper/util/InstructionAnnotation.h"
#import "com/graphhopper/util/InstructionList.h"
#import "com/graphhopper/util/PMap.h"
#import "com/graphhopper/util/Parameters.h"
#import "com/graphhopper/util/PathMerger.h"
#import "com/graphhopper/util/PointList.h"
#import "com/graphhopper/util/StopWatch.h"
#import "com/graphhopper/util/Translation.h"
#import "com/graphhopper/util/TranslationMap.h"
#import "com/graphhopper/util/Unzipper.h"

#import "com/graphhopper/util/exceptions/PointOutOfBoundsException.h"

#import "com/graphhopper/util/shapes/BBox.h"
#import "com/graphhopper/util/shapes/GHPoint.h"

#import "java/io/File.h"
#import "java/io/IOException.h"

#import "java/lang/Boolean.h"
#import "java/lang/Double.h"
#import "java/lang/Deprecated.h"
#import "java/lang/Exception.h"
#import "java/lang/IllegalArgumentException.h"
#import "java/lang/IllegalStateException.h"
#import "java/lang/Integer.h"
#import "java/lang/RuntimeException.h"
#import "java/lang/Throwable.h"
#import "java/lang/UnsupportedOperationException.h"

#import "java/text/DateFormat.h"

#import "java/util/Arrays.h"
#import "java/util/ArrayList.h"
#import "java/util/Collections.h"
#import "java/util/Date.h"
#import "java/util/LinkedHashSet.h"
#import "java/util/List.h"
#import "java/util/Locale.h"
#import "java/util/Set.h"

#import "org/slf4j/Logger.h"
#import "org/slf4j/LoggerFactory.h"



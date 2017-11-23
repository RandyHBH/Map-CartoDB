//
//  WeGoCuba-Bridging-Header.h
//  WeGoCuba
//
//  Created by Randy Hector Bartumeu Huergo on 9/7/17.
//  Copyright © 2017 Randy Hector Bartumeu Huergo. All rights reserved.
//

#import <CartoMobileSDK/CartoMobileSDK.h>

#import "J2ObjC_source.h"
#import "J2ObjC_header.h"
#import "IOSClass.h"
#import "IOSObjectArray.h"

//
//  source: com/graphhopper/*
//
#import "com/graphhopper/GHRequest.h"
#import "com/graphhopper/GHResponse.h"
#import "com/graphhopper/GraphHopper.h"
#import "com/graphhopper/GraphHopperAPI.h"
#import "com/graphhopper/PathWrapper.h"

//
//  source: com/graphhopper/coll/*
//
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

//
//  source: com/graphhopper/geohash/*
//
#import "com/graphhopper/geohash/KeyAlgo.h"
#import "com/graphhopper/geohash/LinearKeyAlgo.h"
#import "com/graphhopper/geohash/SpatialKeyAlgo.h"

//
//  source: com/graphhopper/reader/*
//
#import "com/graphhopper/reader/ConditionalTagInspector.h"
#import "com/graphhopper/reader/DataReader.h"
#import "com/graphhopper/reader/PillarInfo.h"
#import "com/graphhopper/reader/ReaderElement.h"
#import "com/graphhopper/reader/ReaderNode.h"
#import "com/graphhopper/reader/ReaderRelation.h"
#import "com/graphhopper/reader/ReaderWay.h"

//
//  source: com/graphhopper/reader/dem/*
//
#import "com/graphhopper/reader/dem/BridgeElevationInterpolator.h"
#import "com/graphhopper/reader/dem/CGIARProvider.h"
#import "com/graphhopper/reader/dem/ElevationProvider.h"
#import "com/graphhopper/reader/dem/SRTMProvider.h"
#import "com/graphhopper/reader/dem/TunnelElevationInterpolator.h"

//
//  source: com/graphhopper/reader/osm/conditional/*
//

//
//  source: com/graphhopper/routing/*
//
#import "com/graphhopper/routing/AbstractBidirAlgo.h"
#import "com/graphhopper/routing/AbstractRoutingAlgorithm.h"
#import "com/graphhopper/routing/AlgorithmOptions.h"
#import "com/graphhopper/routing/AlternativeRoute.h"
#import "com/graphhopper/routing/AStar.h"
#import "com/graphhopper/routing/AStarBidirection.h"

#import "com/graphhopper/routing/Dijkstra.h"
#import "com/graphhopper/routing/DijkstraBidirectionRef.h"
#import "com/graphhopper/routing/DijkstraOneToMany.h"

#import "com/graphhopper/routing/Path.h"
#import "com/graphhopper/routing/PathBidirRef.h"
#import "com/graphhopper/routing/PathNative.h"

#import "com/graphhopper/routing/QueryGraph.h"

#import "com/graphhopper/routing/RoutingAlgorithm.h"
#import "com/graphhopper/routing/RoutingAlgorithmFactory.h"
#import "com/graphhopper/routing/RoutingAlgorithmFactoryDecorator.h"
#import "com/graphhopper/routing/RoutingAlgorithmFactorySimple.h"

#import "com/graphhopper/routing/VirtualEdgeIterator.h"
#import "com/graphhopper/routing/VirtualEdgeIteratorState.h"

//
//  source: com/graphhopper/routing/ch/*
//
#import "com/graphhopper/routing/ch/CHAlgoFactoryDecorator.h"
#import "com/graphhopper/routing/ch/PrepareContractionHierarchies.h"
#import "com/graphhopper/routing/ch/Path4CH.h"
#import "com/graphhopper/routing/ch/PreparationWeighting.h"
#import "com/graphhopper/routing/ch/PrepareContractionHierarchies.h"
#import "com/graphhopper/routing/ch/PrepareEncoder.h"

//
//  source: com/graphhopper/routing/subnetwork/*
//
#import "com/graphhopper/routing/subnetwork/PrepareRoutingSubnetworks.h"
#import "com/graphhopper/routing/subnetwork/TarjansSCCAlgorithm.h"

//
//  source: com/graphhopper/routing/template/*
//
#import "com/graphhopper/routing/template/AbstractRoutingTemplate.h"
#import "com/graphhopper/routing/template/AlternativeRoutingTemplate.h"
#import "com/graphhopper/routing/template/RoundTripRoutingTemplate.h"
#import "com/graphhopper/routing/template/RoutingTemplate.h"
#import "com/graphhopper/routing/template/ViaRoutingTemplate.h"

//
//  source: com/graphhopper/routing/util/*
//
#import "com/graphhopper/routing/util/AbstractAlgoPreparation.h"
#import "com/graphhopper/routing/util/AbstractFlagEncoder.h"
#import "com/graphhopper/routing/util/AllCHEdgesIterator.h"
#import "com/graphhopper/routing/util/AllEdgesIterator.h"

#import "com/graphhopper/routing/util/Bike2WeightFlagEncoder.h"
#import "com/graphhopper/routing/util/BikeCommonFlagEncoder.h"
#import "com/graphhopper/routing/util/BikeFlagEncoder.h"

#import "com/graphhopper/routing/util/Car4WDFlagEncoder.h"
#import "com/graphhopper/routing/util/CarFlagEncoder.h"

#import "com/graphhopper/routing/util/DataFlagEncoder.h"
#import "com/graphhopper/routing/util/DefaultEdgeFilter.h"
#import "com/graphhopper/routing/util/DefaultFlagEncoderFactory.h"

#import "com/graphhopper/routing/util/EdgeFilter.h"
#import "com/graphhopper/routing/util/EncodedDoubleValue.h"
#import "com/graphhopper/routing/util/EncodedValue.h"
#import "com/graphhopper/routing/util/EncodingManager.h"

#import "com/graphhopper/routing/util/FlagEncoder.h"
#import "com/graphhopper/routing/util/FlagEncoderFactory.h"
#import "com/graphhopper/routing/util/FootFlagEncoder.h"

#import "com/graphhopper/routing/util/HikeFlagEncoder.h"
#import "com/graphhopper/routing/util/HintsMap.h"

#import "com/graphhopper/routing/util/LevelEdgeFilter.h"

#import "com/graphhopper/routing/util/MotorcycleFlagEncoder.h"
#import "com/graphhopper/routing/util/MountainBikeFlagEncoder.h"

#import "com/graphhopper/routing/util/PriorityCode.h"

#import "com/graphhopper/routing/util/RacingBikeFlagEncoder.h"

#import "com/graphhopper/routing/util/TestAlgoCollector.h"
#import "com/graphhopper/routing/util/TraversalMode.h"
#import "com/graphhopper/routing/util/TurnCostEncoder.h"

//
//  source: com/graphhopper/routing/util/tour/*
//
#import "com/graphhopper/routing/util/tour/MultiPointTour.h"
#import "com/graphhopper/routing/util/tour/SinglePointTour.h"
#import "com/graphhopper/routing/util/tour/TourStrategy.h"

//
//  source: com/graphhopper/routing/weighting/*
//
#import "com/graphhopper/routing/weighting/AbstractAdjustedWeighting.h"
#import "com/graphhopper/routing/weighting/AbstractWeighting.h"
#import "com/graphhopper/routing/weighting/AvoidEdgesWeighting.h"
#import "com/graphhopper/routing/weighting/BeelineWeightApproximator.h"
#import "com/graphhopper/routing/weighting/ConsistentWeightApproximator.h"
#import "com/graphhopper/routing/weighting/ConsistentWeightApproximator.h"
#import "com/graphhopper/routing/weighting/CurvatureWeighting.h"
#import "com/graphhopper/routing/weighting/FastestWeighting.h"
#import "com/graphhopper/routing/weighting/GenericWeighting.h"
#import "com/graphhopper/routing/weighting/PriorityWeighting.h"
#import "com/graphhopper/routing/weighting/ShortestWeighting.h"
#import "com/graphhopper/routing/weighting/ShortFastestWeighting.h"
#import "com/graphhopper/routing/weighting/TurnWeighting.h"
#import "com/graphhopper/routing/weighting/WeightApproximator.h"
#import "com/graphhopper/routing/weighting/Weighting.h"

//
//  source: com/graphhopper/search/*
//
#import "com/graphhopper/search/Geocoding.h"
#import "com/graphhopper/search/NameIndex.h"
#import "com/graphhopper/search/ReverseGeocoding.h"

//
//  source: com/graphhopper/storage/*
//
#import "com/graphhopper/storage/AbstractDataAccess.h"
#import "com/graphhopper/storage/BaseGraph.h"
#import "com/graphhopper/storage/CHGraph.h"
#import "com/graphhopper/storage/CHGraphImpl.h"
#import "com/graphhopper/storage/DataAccess.h"
#import "com/graphhopper/storage/DAType.h"
#import "com/graphhopper/storage/Directory.h"
#import "com/graphhopper/storage/EdgeAccess.h"
#import "com/graphhopper/storage/GHDirectory.h"
#import "com/graphhopper/storage/GHNodeAccess.h"
#import "com/graphhopper/storage/Graph.h"
#import "com/graphhopper/storage/GraphBuilder.h"
#import "com/graphhopper/storage/GraphExtension.h"
#import "com/graphhopper/storage/GraphHopperStorage.h"
#import "com/graphhopper/storage/GraphStorage.h"
#import "com/graphhopper/storage/InternalGraphEventListener.h"
#import "com/graphhopper/storage/IntIterator.h"
#import "com/graphhopper/storage/Lock.h"
#import "com/graphhopper/storage/LockFactory.h"
#import "com/graphhopper/storage/MMapDataAccess.h"
#import "com/graphhopper/storage/MMapDirectory.h"
#import "com/graphhopper/storage/NativeFSLockFactory.h"
#import "com/graphhopper/storage/NodeAccess.h"
#import "com/graphhopper/storage/RAMDataAccess.h"
#import "com/graphhopper/storage/RAMDirectory.h"
#import "com/graphhopper/storage/RAMIntDataAccess.h"
#import "com/graphhopper/storage/SimpleFSLockFactory.h"
#import "com/graphhopper/storage/SPTEntry.h"
#import "com/graphhopper/storage/Storable.h"
#import "com/graphhopper/storage/StorableProperties.h"
#import "com/graphhopper/storage/SynchedDAWrapper.h"
#import "com/graphhopper/storage/TurnCostExtension.h"
#import "com/graphhopper/storage/UnsafeDataAccess.h"
#import "com/graphhopper/storage/VLongStorage.h"

//
//  source: com/graphhopper/storage/index/*
//
#import "com/graphhopper/storage/index/BresenhamLine.h"
#import "com/graphhopper/storage/index/Location2IDFullIndex.h"
#import "com/graphhopper/storage/index/Location2IDFullWithEdgesIndex.h"
#import "com/graphhopper/storage/index/Location2IDQuadtree.h"
#import "com/graphhopper/storage/index/LocationIndex.h"
#import "com/graphhopper/storage/index/LocationIndexTree.h"
#import "com/graphhopper/storage/index/PointEmitter.h"
#import "com/graphhopper/storage/index/QueryResult.h"

//
//  source: com/graphhopper/util/*
//
#import "com/graphhopper/util/AngleCalc.h"
#import "com/graphhopper/util/BitUtil.h"
#import "com/graphhopper/util/BitUtilBig.h"
#import "com/graphhopper/util/BitUtilLittle.h"
#import "com/graphhopper/util/BreadthFirstSearch.h"
#import "com/graphhopper/util/CHEdgeExplorer.h"
#import "com/graphhopper/util/CHEdgeIterator.h"
#import "com/graphhopper/util/CHEdgeIteratorState.h"
#import "com/graphhopper/util/CmdArgs.h"
#import "com/graphhopper/util/ConfigMap.h"
#import "com/graphhopper/util/Constants.h"
#import "com/graphhopper/util/DepthFirstSearch.h"
#import "com/graphhopper/util/DistanceCalc.h"
#import "com/graphhopper/util/DistanceCalc2D.h"
#import "com/graphhopper/util/DistanceCalc3D.h"
#import "com/graphhopper/util/DistanceCalcEarth.h"
#import "com/graphhopper/util/DistancePlaneProjection.h"
#import "com/graphhopper/util/DouglasPeucker.h"
#import "com/graphhopper/util/Downloader.h"
#import "com/graphhopper/util/EdgeExplorer.h"
#import "com/graphhopper/util/EdgeIterator.h"
#import "com/graphhopper/util/EdgeIteratorState.h"
#import "com/graphhopper/util/FinishInstruction.h"
#import "com/graphhopper/util/GHUtility.h"
#import "com/graphhopper/util/GPXEntry.h"
#import "com/graphhopper/util/Helper.h"
#import "com/graphhopper/util/Instruction.h"
#import "com/graphhopper/util/InstructionAnnotation.h"
#import "com/graphhopper/util/InstructionList.h"
#import "com/graphhopper/util/MiniPerfTest.h"
#import "com/graphhopper/util/NotThreadSafe.h"
#import "com/graphhopper/util/NumHelper.h"
#import "com/graphhopper/util/Parameters.h"
#import "com/graphhopper/util/PathMerger.h"
#import "com/graphhopper/util/PMap.h"
#import "com/graphhopper/util/PointAccess.h"
#import "com/graphhopper/util/PointList.h"
#import "com/graphhopper/util/ProgressListener.h"
#import "com/graphhopper/util/RoundaboutInstruction.h"
#import "com/graphhopper/util/SimpleIntDeque.h"
#import "com/graphhopper/util/StopWatch.h"
#import "com/graphhopper/util/Translation.h"
#import "com/graphhopper/util/TranslationMap.h"
#import "com/graphhopper/util/Unzipper.h"
#import "com/graphhopper/util/ViaInstruction.h"
#import "com/graphhopper/util/XFirstSearch.h"

//
//  source: com/graphhopper/util/exceptions/*
//
#import "com/graphhopper/util/exceptions/ConnectionNotFoundException.h"
#import "com/graphhopper/util/exceptions/DetailedIllegalArgumentException.h"
#import "com/graphhopper/util/exceptions/DetailedRuntimeException.h"
#import "com/graphhopper/util/exceptions/GHException.h"
#import "com/graphhopper/util/exceptions/PointNotFoundException.h"
#import "com/graphhopper/util/exceptions/PointOutOfBoundsException.h"

//
//  source: com/graphhopper/util/shapes/*
//
#import "com/graphhopper/util/shapes/BBox.h"
#import "com/graphhopper/util/shapes/Circle.h"
#import "com/graphhopper/util/shapes/GHPlace.h"
#import "com/graphhopper/util/shapes/GHPoint.h"
#import "com/graphhopper/util/shapes/GHPoint3D.h"
#import "com/graphhopper/util/shapes/Shape.h"

//
//  source: gnu/trove/*
//
#import "gnu/trove/list/TIntList.h"
#import "gnu/trove/list/array/TIntArrayList.h"
#import "gnu/trove/map/TIntObjectMap.h"
#import "gnu/trove/map/hash/TIntObjectHashMap.h"
#import "gnu/trove/set/hash/TIntHashSet.h"

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
#import "java/lang/Math.h"
#import "java/lang/UnsupportedOperationException.h"

#import "java/text/DateFormat.h"

#import "java/util/Arrays.h"
#import "java/util/ArrayList.h"
#import "java/util/Collections.h"
#import "java/util/Date.h"
#import "java/util/HashMap.h"
#import "java/util/LinkedHashSet.h"
#import "java/util/List.h"
#import "java/util/Locale.h"
#import "java/util/Map.h"
#import "java/util/Set.h"

#import "org/slf4j/Logger.h"
#import "org/slf4j/LoggerFactory.h"



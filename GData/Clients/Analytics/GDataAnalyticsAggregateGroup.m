/* Copyright (c) 2009 Google Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

//
//  GDataAnalyticsAggregateGroup.m
//


#import "GDataAnalyticsAggregateGroup.h"

#import "GDataAnalyticsConstants.h"
#import "GDataAnalyticsMetric.h"

@implementation GDataAnalyticsAggregateGroup

+ (NSString *)extensionElementURI       { return kGDataNamespaceAnalytics; }
+ (NSString *)extensionElementPrefix    { return kGDataNamespaceAnalyticsPrefix; }
+ (NSString *)extensionElementLocalName { return @"aggregates"; }

- (void)addExtensionDeclarations {
  [super addExtensionDeclarations];

  [self addExtensionDeclarationForParentClass:[self class]
                                   childClass:[GDataAnalyticsMetric class]];
}

#if !GDATA_SIMPLE_DESCRIPTIONS
- (NSMutableArray *)itemsForDescription {

  static struct GDataDescriptionRecord descRecs[] = {
    { @"metrics", @"metrics", kGDataDescArrayDescs },
    { nil, nil, 0 }
  };

  NSMutableArray *items = [super itemsForDescription];
  [self addDescriptionRecords:descRecs toItems:items];
  return items;
}
#endif

#pragma mark -

- (NSArray *)metrics {
  return [self objectsForExtensionClass:[GDataAnalyticsMetric class]];
}

- (void)setMetrics:(NSArray *)array {
  [self setObjects:array forExtensionClass:[GDataAnalyticsMetric class]];
}

- (void)addMetric:(GDataAnalyticsMetric *)obj {
  [self addObject:obj forExtensionClass:[GDataAnalyticsMetric class]];
}

@end
